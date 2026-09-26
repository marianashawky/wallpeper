import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_info.dart';
import '../domain/wallpaper.dart';

class ShareService {
  Future<void> share(Wallpaper wallpaper, {required bool highQuality}) async {
    final caption = '${wallpaper.title} — ${AppInfo.name}';
    if (wallpaper.source == MediaSource.asset && !wallpaper.playsVideo) {
      final data = await rootBundle.load(wallpaper.imageUrl);
      await Share.shareXFiles(
        [
          XFile.fromData(
            data.buffer.asUint8List(),
            mimeType: 'image/jpeg',
            name: 'lumen_${wallpaper.id}.jpg',
          ),
        ],
        text: caption,
      );
      return;
    }
    final link = wallpaper.playsVideo ? wallpaper.previewUrl : wallpaper.imageUrl;
    await Share.share('$caption\n$link');
  }
}
