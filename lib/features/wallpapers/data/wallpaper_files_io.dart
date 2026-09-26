import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/wallpaper.dart';

class WallpaperFiles {
  Future<File> materialize(
    Wallpaper wallpaper, {
    required bool highQuality,
    bool video = false,
    void Function(double progress)? onProgress,
  }) async {
    final bytes = video ? await _videoBytes(wallpaper, onProgress) : await _imageBytes(wallpaper, highQuality, onProgress);
    final extension = video ? 'mp4' : 'jpg';
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/lumen_${wallpaper.id}.$extension');
    await file.writeAsBytes(bytes, flush: true);
    onProgress?.call(1);
    return file;
  }

  Future<Uint8List> _imageBytes(Wallpaper wallpaper, bool highQuality, void Function(double progress)? onProgress) async {
    if (wallpaper.source == MediaSource.asset) {
      onProgress?.call(0.4);
      final data = await rootBundle.load(wallpaper.imageUrl);
      return data.buffer.asUint8List();
    }
    final url = _sized(wallpaper.imageUrl, highQuality ? 1600 : 1080);
    return _download(url, onProgress);
  }

  Future<Uint8List> _videoBytes(Wallpaper wallpaper, void Function(double progress)? onProgress) async {
    final url = wallpaper.previewUrl;
    if (url == null || url.isEmpty) {
      throw const FileSystemException('This wallpaper has no video file.');
    }
    return _download(url, onProgress);
  }

  Future<Uint8List> _download(String url, void Function(double progress)? onProgress) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw FileSystemException('Download failed (${response.statusCode}).');
      }
      final total = response.contentLength;
      final builder = BytesBuilder(copy: false);
      var received = 0;
      await for (final chunk in response) {
        builder.add(chunk);
        received += chunk.length;
        if (total > 0) onProgress?.call(received / total);
      }
      return builder.takeBytes();
    } finally {
      client.close();
    }
  }

  String _sized(String url, int width) {
    final uri = Uri.parse(url);
    if (!uri.host.contains('unsplash.com')) return url;
    final params = Map<String, String>.from(uri.queryParameters);
    params['w'] = '$width';
    params['h'] = '${(width * 1.6).round()}';
    return uri.replace(queryParameters: params).toString();
  }
}
