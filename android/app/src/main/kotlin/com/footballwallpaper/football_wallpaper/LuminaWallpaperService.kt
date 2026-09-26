package com.footballwallpaper.football_wallpaper

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Matrix
import android.graphics.Paint
import android.media.MediaPlayer
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.service.wallpaper.WallpaperService
import android.view.SurfaceHolder
import kotlin.math.sin

class LuminaWallpaperService : WallpaperService() {
    companion object {
        const val PREFS = "live_wp"
        const val KEY_PATH = "path"
        const val KEY_KIND = "kind"
        const val ACTION_RELOAD = "com.footballwallpaper.football_wallpaper.RELOAD_LIVE"
    }

    override fun onCreateEngine(): Engine = LiveEngine()

    inner class LiveEngine : Engine() {
        private val handler = Handler(Looper.getMainLooper())
        private val paint = Paint(Paint.FILTER_BITMAP_FLAG or Paint.ANTI_ALIAS_FLAG)
        private val matrix = Matrix()
        private var bitmap: Bitmap? = null
        private var player: MediaPlayer? = null
        private var visible = false
        private var kind = "motion"
        private var path: String? = null
        private var startedAt = SystemClock.elapsedRealtime()

        private val reload = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                readPrefs()
                if (kind == "video") startVideo() else restartMotion()
            }
        }

        private val tick = object : Runnable {
            override fun run() {
                if (kind == "video") return
                drawFrame()
                if (visible) handler.postDelayed(this, 32L)
            }
        }

        override fun onCreate(surfaceHolder: SurfaceHolder) {
            super.onCreate(surfaceHolder)
            val filter = IntentFilter(ACTION_RELOAD)
            if (Build.VERSION.SDK_INT >= 33) {
                applicationContext.registerReceiver(reload, filter, Context.RECEIVER_NOT_EXPORTED)
            } else {
                @Suppress("DEPRECATION")
                applicationContext.registerReceiver(reload, filter)
            }
            readPrefs()
        }

        override fun onDestroy() {
            handler.removeCallbacks(tick)
            stopVideo()
            try {
                applicationContext.unregisterReceiver(reload)
            } catch (_: Exception) {
            }
            bitmap?.recycle()
            bitmap = null
            super.onDestroy()
        }

        override fun onVisibilityChanged(visible: Boolean) {
            this.visible = visible
            handler.removeCallbacks(tick)
            if (!visible) {
                if (player?.isPlaying == true) player?.pause()
                return
            }
            readPrefs()
            if (kind == "video") {
                if (player == null) startVideo() else player?.start()
            } else {
                stopVideo()
                loadBitmap()
                handler.post(tick)
            }
        }

        override fun onSurfaceCreated(holder: SurfaceHolder) {
            super.onSurfaceCreated(holder)
            if (kind == "video" && visible) startVideo()
        }

        override fun onSurfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
            super.onSurfaceChanged(holder, format, width, height)
            if (kind == "video") {
                player?.setSurface(holder.surface)
            } else {
                drawFrame()
            }
        }

        override fun onSurfaceDestroyed(holder: SurfaceHolder) {
            stopVideo()
            super.onSurfaceDestroyed(holder)
        }

        private fun readPrefs() {
            val prefs = getSharedPreferences(PREFS, MODE_PRIVATE)
            path = prefs.getString(KEY_PATH, null)
            kind = prefs.getString(KEY_KIND, "motion") ?: "motion"
        }

        private fun restartMotion() {
            stopVideo()
            loadBitmap()
            if (visible) {
                handler.removeCallbacks(tick)
                handler.post(tick)
            }
        }

        private fun startVideo() {
            val source = path ?: return
            if (!surfaceHolder.surface.isValid) return
            stopVideo()
            handler.removeCallbacks(tick)
            val media = MediaPlayer()
            player = media
            try {
                media.setSurface(surfaceHolder.surface)
                media.setDataSource(source)
                media.isLooping = true
                media.setVolume(0f, 0f)
                if (Build.VERSION.SDK_INT >= 16) {
                    media.setVideoScalingMode(MediaPlayer.VIDEO_SCALING_MODE_SCALE_TO_FIT_WITH_CROPPING)
                }
                media.setOnPreparedListener { prepared ->
                    if (visible) prepared.start()
                }
                media.setOnErrorListener { _, _, _ -> true }
                media.prepareAsync()
            } catch (_: Exception) {
                stopVideo()
            }
        }

        private fun stopVideo() {
            player?.run {
                try {
                    stop()
                } catch (_: Exception) {
                }
                release()
            }
            player = null
        }

        private fun loadBitmap() {
            val source = path ?: return
            val (w, h) = WallpaperBitmaps.screenSize(this@LuminaWallpaperService)
            val decoded = WallpaperBitmaps.decode(source, w, h) ?: return
            val old = bitmap
            bitmap = decoded
            if (old != null && old !== decoded) old.recycle()
            startedAt = SystemClock.elapsedRealtime()
        }

        private fun drawFrame() {
            val canvas = surfaceHolder.lockCanvas() ?: return
            try {
                canvas.drawColor(Color.BLACK)
                val bmp = bitmap ?: return
                val cw = canvas.width.toFloat().coerceAtLeast(1f)
                val ch = canvas.height.toFloat().coerceAtLeast(1f)
                val cycle = ((SystemClock.elapsedRealtime() - startedAt) % 8000L) / 8000f
                val ping = if (cycle < 0.5f) cycle * 2f else (1f - cycle) * 2f
                val ease = ping * ping * (3f - 2f * ping)
                val extra = 1f + 0.045f * ease
                val base = maxOf(cw / bmp.width, ch / bmp.height)
                val scale = base * extra
                val dx = (cw - bmp.width * scale) / 2f + 10f * (ease - 0.5f)
                val dy = (ch - bmp.height * scale) / 2f + 8f * sin(ease * Math.PI).toFloat()
                matrix.reset()
                matrix.postScale(scale, scale)
                matrix.postTranslate(dx, dy)
                canvas.drawBitmap(bmp, matrix, paint)
            } finally {
                surfaceHolder.unlockCanvasAndPost(canvas)
            }
        }
    }
}
