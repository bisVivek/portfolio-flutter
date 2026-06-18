import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'portfolio_video_player.dart';

/// Animated media card with hover lift, glow, and tilt.
class AnimatedMediaCard extends StatefulWidget {
  const AnimatedMediaCard({
    super.key,
    required this.media,
    this.dark = false,
    this.aspectRatio = 4 / 3,
    this.tall = false,
  });

  final MediaAsset media;
  final bool dark;
  final double aspectRatio;
  final bool tall;

  @override
  State<AnimatedMediaCard> createState() => _AnimatedMediaCardState();
}

class _AnimatedMediaCardState extends State<AnimatedMediaCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final titleColor = AppTheme.onSection(widget.dark);
    final subColor = AppTheme.onSectionMuted(widget.dark);
    final borderColor =
        _hovering ? AppTheme.neon : AppTheme.sectionBorder(widget.dark);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translateByDouble(0.0, _hovering ? -8.0 : 0.0, 0.0, 1.0)
          ..rotateZ(_hovering ? -0.008 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: _hovering ? 2 : 1),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: AppTheme.neon.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMedia(),
            Container(
              color: widget.dark ? const Color(0xFF111111) : AppTheme.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.media.projectTag != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.neon,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        widget.media.projectTag!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: AppTheme.black,
                        ),
                      ),
                    ),
                  Text(
                    widget.media.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: titleColor,
                    ),
                  ),
                  if (widget.media.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.media.subtitle!,
                      style: TextStyle(fontSize: 13, color: subColor),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedia() {
    if (widget.media.type == MediaType.video) {
      return PortfolioVideoPlayer(
        assetPath: widget.media.path,
        height: widget.tall ? 320 : 240,
      );
    }

    return AspectRatio(
      aspectRatio: widget.tall ? 3 / 4 : widget.aspectRatio,
      child: Image.asset(
        widget.media.path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: AppTheme.backgroundAlt,
          child: const Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }
}
