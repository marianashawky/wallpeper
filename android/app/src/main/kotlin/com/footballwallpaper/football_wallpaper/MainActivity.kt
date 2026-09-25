package com.footballwallpaper.football_wallpaper

import android.app.WallpaperManager
import android.content.ComponentName
import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "football_wallpaper/native")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "sdkInt" -> result.success(Build.VERSION.SDK_INT)
                    "setWallpaper" -> {
                        val path = call.argument<String>("path")
                        result.success(if (path.isNullOrEmpty()) "fail" else applyStatic(path))
                    }
                    "setLiveWallpaper" -> {
                        val path = call.argument<String>("path")
                        result.success(if (path.isNullOrEmpty()) "fail" else applyLive(path))
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun applyStatic(path: String): String {
        return try {
            val (w, h) = WallpaperBitmaps.screenSize(this)
            val decoded = WallpaperBitmaps.decode(path, w, h) ?: return "fail"
            val fitted = WallpaperBitmaps.containOnScreen(decoded, w, h)
            if (fitted !== decoded) decoded.recycle()
            val wm = WallpaperManager.getInstance(this)
            if (Build.VERSION.SDK_INT >= 24) {
                wm.setBitmap(
                    fitted,
                    null,
                    true,
                    WallpaperManager.FLAG_SYSTEM or WallpaperManager.FLAG_LOCK,
                )
            } else {
                @Suppress("DEPRECATION")
                wm.setBitmap(fitted)
            }
            "ok"
        } catch (_: Exception) {
            "fail"
        }
    }

    private fun applyLive(path: String): String {
        return try {
            val dest = File(filesDir, "live_current.jpg")
            File(path).copyTo(dest, overwrite = true)
            getSharedPreferences(LiveFootballWallpaperService.PREFS, MODE_PRIVATE)
                .edit()
                .putString(LiveFootballWallpaperService.KEY_PATH, dest.absolutePath)
                .apply()
            sendBroadcast(
                Intent(LiveFootballWallpaperService.ACTION_RELOAD).setPackage(packageName),
            )
            val info = WallpaperManager.getInstance(this).wallpaperInfo
            val alreadyOurs = info?.component?.className == LiveFootballWallpaperService::class.java.name
            if (alreadyOurs) return "ok"
            val intent = Intent(WallpaperManager.ACTION_CHANGE_LIVE_WALLPAPER).apply {
                putExtra(
                    WallpaperManager.EXTRA_LIVE_WALLPAPER_COMPONENT,
                    ComponentName(this@MainActivity, LiveFootballWallpaperService::class.java),
                )
            }
            try {
                startActivity(intent)
                "picker"
            } catch (_: Exception) {
                applyStatic(dest.absolutePath)
            }
        } catch (_: Exception) {
            "fail"
        }
    }
}
