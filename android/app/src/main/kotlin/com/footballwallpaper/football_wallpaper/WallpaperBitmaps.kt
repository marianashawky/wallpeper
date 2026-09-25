package com.footballwallpaper.football_wallpaper

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import kotlin.math.min

object WallpaperBitmaps {
    fun screenSize(context: Context): Pair<Int, Int> {
        val dm = context.resources.displayMetrics
        return dm.widthPixels.coerceAtLeast(1) to dm.heightPixels.coerceAtLeast(1)
    }

    fun decode(path: String, targetW: Int, targetH: Int): Bitmap? {
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(path, bounds)
        if (bounds.outWidth <= 0 || bounds.outHeight <= 0) return null
        var sample = 1
        while (bounds.outWidth / sample / 2 >= targetW && bounds.outHeight / sample / 2 >= targetH) {
            sample *= 2
        }
        return BitmapFactory.decodeFile(
            path,
            BitmapFactory.Options().apply {
                inSampleSize = sample
                inPreferredConfig = Bitmap.Config.ARGB_8888
            },
        )
    }

    fun containOnScreen(src: Bitmap, screenW: Int, screenH: Int): Bitmap {
        if (src.width == screenW && src.height == screenH) return src
        val out = Bitmap.createBitmap(screenW, screenH, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(out)
        canvas.drawColor(Color.BLACK)
        val scale = min(screenW.toFloat() / src.width, screenH.toFloat() / src.height)
        val dw = src.width * scale
        val dh = src.height * scale
        val left = (screenW - dw) / 2f
        val top = (screenH - dh) / 2f
        canvas.drawBitmap(
            src,
            null,
            RectF(left, top, left + dw, top + dh),
            Paint(Paint.FILTER_BITMAP_FLAG),
        )
        return out
    }
}
