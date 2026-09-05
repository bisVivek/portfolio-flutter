import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/portfolio_data.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'animated_media_card.dart';
import 'reveal_on_scroll.dart';

/// Apple-style 3D product showcase for App Demos & Screenshots.
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
    _videoPageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _videoPageController.dispose();
    super.dispose();
  }

  void _nextDemo(int total) {
    final next = (_videoPage + 1) % total;
    _videoPageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _prevDemo(int total) {
    final prev = (_videoPage - 1 + total) % total;
    _videoPageController.animateToPage(
      prev,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
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
        // SECTION 03 Header
        RevealOnScroll(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.purple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppTheme.purple.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Text(
                      'CINEMATIC SHOWCASE',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        fontSize: 10,
                        color: AppTheme.purple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'APP DEMOS',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: isWide ? 32 : 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: AppTheme.black,
                        ),
                  ),
                ],
              ),
              if (videos.isNotEmpty)
                Row(
                  children: [
                    _NavIconButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => _prevDemo(videos.length),
                    ),
                    const SizedBox(width: 8),
                    _NavIconButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: () => _nextDemo(videos.length),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Apple-Style 3D Smartphone Stage Presentation
        if (videos.isNotEmpty) ...[
          SizedBox(
            height: isWide ? 400 : 320,
            child: PageView.builder(
              controller: _videoPageController,
              onPageChanged: (i) => setState(() => _videoPage = i),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final isCurrent = index == _videoPage;
                final media = videos[index];

                return AnimatedScale(
                  scale: isCurrent ? 1.0 : 0.88,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ambient backdrop glow for center phone
                      if (isCurrent)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.purple.withValues(alpha: 0.25),
                                  blurRadius: 60,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Smartphone Glass Frame Composition
                      Container(
                        width: isWide ? 300 : 230,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0F1A),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: isCurrent
                                ? AppTheme.purple
                                : Colors.black12,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                  alpha: isCurrent ? 0.35 : 0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            // Main Demo Media Content
                            Positioned.fill(
                              child: AnimatedMediaCard(
                                media: media,
                                tall: true,
                              ),
                            ),

                            // Floating Glass Badge overlay on Center Phone
                            Positioned(
                              top: 14,
                              left: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.neon,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      media.projectTag ?? 'Demo',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: 20),

          // Indicator Dots Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              videos.length,
              (i) => InkWell(
                onTap: () => _videoPageController.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                ),
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: i == _videoPage ? 28 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: i == _videoPage ? AppTheme.purple : AppTheme.border,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: i == _videoPage
                        ? [
                            BoxShadow(
                              color: AppTheme.purple.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 56),
        ],

        // PROJECT SCREENSHOTS Horizontal Scroll Strip
        RevealOnScroll(
          child: Text(
            'PROJECT SCREENSHOTS & PRODUCTION ASSETS',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 11,
              color: AppTheme.purple,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: isWide ? 300 : 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 18),
            itemBuilder: (context, index) {
              return SizedBox(
                width: isWide ? 360 : 270,
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

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.backgroundAlt,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        hoverColor: AppTheme.purple.withValues(alpha: 0.15),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.black,
          ),
        ),
      ),
    );
  }
}

