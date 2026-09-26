import 'dart:io';

import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/local/local_store.dart';
import '../domain/download_result.dart';
import '../domain/wallpaper.dart';
import 'wallpaper_files_io.dart';

class DownloadService {
  DownloadService({required LocalStore store, WallpaperFiles? files})
      : _store = store,
        _files = files ?? WallpaperFiles();

  final LocalStore _store;
  final WallpaperFiles _files;

  Future<DownloadResult> download(
    Wallpaper wallpaper, {
    required bool highQuality,
    void Function(double progress)? onProgress,
  }) async {
    if (_store.isDownloaded(wallpaper.id)) {
      return const DownloadResult(DownloadStatus.alreadySaved, 'Already saved on this device.');
    }
    try {
      if (Platform.isAndroid) {
        await Permission.photos.request();
        await Permission.videos.request();
        await Permission.storage.request();
      }
      final video = wallpaper.playsVideo;
      final file = await _files.materialize(
        wallpaper,
        highQuality: highQuality,
        video: video,
        onProgress: onProgress,
      );
      final name = 'lumen_${wallpaper.id}';
      final dynamic result = video
          ? await ImageGallerySaverPlus.saveFile(file.path, name: name)
          : await ImageGallerySaverPlus.saveImage(
              await file.readAsBytes(),
              quality: 100,
              name: name,
            );
      final saved = result is Map && (result['isSuccess'] == true || result['filePath'] != null);
      if (!saved) {
        return const DownloadResult(DownloadStatus.failed, 'Could not save the wallpaper. Check storage permission.');
      }
      await _store.addDownload(wallpaper.id);
      return const DownloadResult(DownloadStatus.saved, 'Saved to your gallery.');
    } catch (_) {
      return const DownloadResult(DownloadStatus.failed, 'Could not save the wallpaper.');
    }
  }
}
