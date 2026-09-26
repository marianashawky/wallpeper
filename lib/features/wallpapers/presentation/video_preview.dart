import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../shared/widgets/wallpaper_image.dart';
import '../domain/wallpaper.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({super.key, required this.wallpaper, required this.autoplay});

  final Wallpaper wallpaper;
  final bool autoplay;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  var _failed = false;
  var _ready = false;
  var _muted = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _open();
  }

  Future<void> _open() async {
    final url = widget.wallpaper.previewUrl;
    if (url == null || url.isEmpty) {
      setState(() => _failed = true);
      return;
    }
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controller = controller;
    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      if (!mounted) return;
      setState(() => _ready = true);
      if (widget.autoplay) await controller.play();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _controller?.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    final controller = _controller;
    if (controller == null || !_ready) return;
    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
    if (mounted) setState(() {});
  }

  Future<void> _toggleMute() async {
    final controller = _controller;
    if (controller == null) return;
    _muted = !_muted;
    await controller.setVolume(_muted ? 0 : 1);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final playing = controller?.value.isPlaying ?? false;
    return Stack(
      fit: StackFit.expand,
      children: [
        WallpaperImage(wallpaper: widget.wallpaper, thumbnail: false),
        if (_ready && controller != null)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        if (!_ready && !_failed) const Center(child: CircularProgressIndicator(color: Colors.white)),
        if (_failed)
          const Center(
            child: Text('Preview unavailable', style: TextStyle(color: Colors.white)),
          ),
        Positioned(
          top: 64,
          right: 12,
          child: Column(
            children: [
              _round(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                playing ? 'Pause preview' : 'Play preview',
                _ready ? _togglePlay : null,
              ),
              const SizedBox(height: 8),
              _round(
                _muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                _muted ? 'Unmute' : 'Mute',
                _ready ? _toggleMute : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _round(IconData icon, String tooltip, VoidCallback? onPressed) {
    return Material(
      color: const Color(0xB3101114),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
