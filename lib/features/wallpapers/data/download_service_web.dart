import '../../../data/local/local_store.dart';
import '../domain/download_result.dart';
import '../domain/wallpaper.dart';

class DownloadService {
  DownloadService({required LocalStore store});

  Future<DownloadResult> download(
    Wallpaper wallpaper, {
    required bool highQuality,
    void Function(double progress)? onProgress,
  }) async {
    return const DownloadResult(DownloadStatus.failed, 'Saving to the gallery is available on Android.');
  }
}
