import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';

class PortfolioVideoPlayer extends StatefulWidget {
  const PortfolioVideoPlayer({
    super.key,
    required this.assetPath,
    this.height = 280,
  });

  final String assetPath;
  final double height;

  @override
  State<PortfolioVideoPlayer> createState() => _PortfolioVideoPlayerState();
}

class _PortfolioVideoPlayerState extends State<PortfolioVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          _controller.setLooping(true);
        }
      }).catchError((_) {
        if (mounted) setState(() => _hasError = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_initialized)
                  FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                else if (_hasError)
                  Container(
                    color: AppTheme.backgroundAlt,
                    child: const Center(
                      child: Icon(Icons.videocam_off_outlined, size: 40),
                    ),
                  )
                else
                  Container(
                    color: const Color(0xFF111111),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.neon,
                      ),
                    ),
                  ),
                if (_initialized)
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _togglePlay,
                        child: AnimatedOpacity(
                          opacity:
                              _controller.value.isPlaying && !_hovering ? 0 : 1,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            color: Colors.black38,
                            child: Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.all(_hovering ? 20 : 16),
                                decoration: BoxDecoration(
                                  color: AppTheme.neon,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.neon.withValues(
                                        alpha: _hovering ? 0.5 : 0.2,
                                      ),
                                      blurRadius: _hovering ? 24 : 12,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: _hovering ? 36 : 32,
                                  color: AppTheme.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
