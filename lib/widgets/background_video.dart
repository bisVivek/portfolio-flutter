import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';

/// Ambient high-tech background video widget powered by [video_player].
class BackgroundVideo extends StatefulWidget {
  const BackgroundVideo({
    super.key,
    this.assetPath = 'assets/videoes/pvb.mp4',
    this.overlayOpacity = 0.55,
    this.showControls = false,
    this.child,
  });

  final String assetPath;
  final double overlayOpacity;
  final bool showControls;
  final Widget? child;

  @override
  State<BackgroundVideo> createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        if (mounted) {
          _controller.setLooping(true);
          _controller.setVolume(0.0);
          _controller.play();
          setState(() {
            _initialized = true;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMute() {
    if (!_initialized) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _togglePlay() {
    if (!_initialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video Layer
        if (_initialized && !_hasError)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width > 0
                  ? _controller.value.size.width
                  : 1920,
              height: _controller.value.size.height > 0
                  ? _controller.value.size.height
                  : 1080,
              child: VideoPlayer(_controller),
            ),
          )
        else
          Container(
            color: AppTheme.black,
          ),

        // Dark ambient overlay gradient for maximum text contrast
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.black.withValues(alpha: widget.overlayOpacity + 0.15),
                AppTheme.black.withValues(alpha: widget.overlayOpacity),
                AppTheme.black.withValues(alpha: widget.overlayOpacity + 0.25),
              ],
            ),
          ),
        ),

        // Radial Vignette Overlay for dark cinematic style
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.transparent,
                AppTheme.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),

        // Optional Child Widget on top of video background
        if (widget.child != null) widget.child!,

        // Optional Quick Video Controls
        if (widget.showControls && _initialized)
          Positioned(
            right: 24,
            bottom: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ControlButton(
                  icon: _controller.value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  tooltip: _controller.value.isPlaying ? 'Pause Video' : 'Play Video',
                  onTap: _togglePlay,
                ),
                const SizedBox(width: 10),
                _ControlButton(
                  icon: _isMuted
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                  tooltip: _isMuted ? 'Unmute Audio' : 'Mute Audio',
                  onTap: _toggleMute,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.black.withValues(alpha: 0.65),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.neon.withValues(alpha: 0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neon.withValues(alpha: 0.15),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppTheme.neon,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
