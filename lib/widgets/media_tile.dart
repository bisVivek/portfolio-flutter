import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import '../widgets/portfolio_video_player.dart';
import '../widgets/hover_card.dart';

class MediaTile extends StatelessWidget {
  const MediaTile({super.key, required this.media, this.dark = false});

  final MediaAsset media;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final titleColor = AppTheme.onSection(dark);
    final subColor = AppTheme.onSectionMuted(dark);

    return HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (media.type == MediaType.video)
            PortfolioVideoPlayer(assetPath: media.path, height: 260)
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(
                  media.path,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: dark ? const Color(0xFF111111) : AppTheme.backgroundAlt,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            media.title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: titleColor,
            ),
          ),
          if (media.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              media.subtitle!,
              style: TextStyle(color: subColor, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
