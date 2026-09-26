import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/wallpaper.dart';

class WallpaperActions {
  Future<bool> download(Wallpaper wallpaper) async {
    await share(wallpaper);
    return true;
  }

  Future<void> share(Wallpaper wallpaper) async {
    final data = await rootBundle.load(wallpaper.imagePath);
    await Share.shareXFiles(
      [
        XFile.fromData(
          data.buffer.asUint8List(),
          mimeType: 'image/jpeg',
          name: '${wallpaper.id}.jpg',
        ),
      ],
      text: '${wallpaper.title} — Football Wallpaper',
    );
  }

  Future<String> setWallpaper(Wallpaper wallpaper) async => 'fail';
}
