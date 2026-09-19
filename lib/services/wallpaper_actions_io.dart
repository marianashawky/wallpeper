import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/wallpaper.dart';

class WallpaperActions {
  static const _channel = MethodChannel('football_wallpaper/native');

  Future<File> _materialize(Wallpaper wallpaper) async {
    final data = await rootBundle.load(wallpaper.imagePath);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${wallpaper.id}.jpg');
    await file.writeAsBytes(data.buffer.asUint8List());
    return file;
  }

  Future<bool> download(Wallpaper wallpaper) async {
    if (Platform.isAndroid) {
      await Permission.photos.request();
      await Permission.storage.request();
    }
    final data = await rootBundle.load(wallpaper.imagePath);
    final result = await ImageGallerySaverPlus.saveImage(
      data.buffer.asUint8List(),
      quality: 100,
      name: wallpaper.id,
    );
    return result is Map && (result['isSuccess'] == true || result['filePath'] != null);
  }

  Future<void> share(Wallpaper wallpaper) async {
    final file = await _materialize(wallpaper);
    await Share.shareXFiles([XFile(file.path)], text: '${wallpaper.title} — Football Wallpaper');
  }

  Future<bool> setWallpaper(Wallpaper wallpaper) async {
    if (!Platform.isAndroid) return false;
    final file = await _materialize(wallpaper);
    try {
      final ok = await _channel.invokeMethod<bool>('setWallpaper', {'path': file.path});
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }
}
