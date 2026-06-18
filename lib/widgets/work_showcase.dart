import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/portfolio_data.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'animated_media_card.dart';
import 'reveal_on_scroll.dart';

/// Work demos & screenshots — lives inside the Work section.
class WorkShowcase extends StatefulWidget {
  const WorkShowcase({super.key});

  @override
  State<WorkShowcase> createState() => _WorkShowcaseState();
}

class _WorkShowcaseState extends State<WorkShowcase> {
  late final PageController _videoPageController;
  int _videoPage = 0;

  @override
  void initState() {
    super.initState();
    _videoPageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _videoPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final videos = PortfolioData.workMedia
        .where((m) => m.type == MediaType.video)
        .toList();
    final images = PortfolioData.workMedia
        .where((m) => m.type == MediaType.image)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          child: Text(
            'APP DEMOS & SCREENSHOTS',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 12,
              color: AppTheme.purple,
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (videos.isNotEmpty) ...[
          SizedBox(
            height: isWide ? 340 : 280,
            child: PageView.builder(
              controller: _videoPageController,
              onPageChanged: (i) => setState(() => _videoPage = i),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StaggerReveal(
                    index: index,
                    child: AnimatedMediaCard(
                      media: videos[index],
                      tall: true,
                    ),
                  ),
                );
              },
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: 0.05, end: 0),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              videos.length,
              (i) => AnimatedContainer(
                duration: 300.ms,
                width: i == _videoPage ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: i == _videoPage ? AppTheme.neon : AppTheme.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
        RevealOnScroll(
          child: Text(
            'PROJECT SCREENSHOTS',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 12,
              color: AppTheme.purple,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: isWide ? 320 : 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              return SizedBox(
                width: isWide ? 380 : 280,
                child: StaggerReveal(
                  index: index,
                  child: AnimatedMediaCard(media: images[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
