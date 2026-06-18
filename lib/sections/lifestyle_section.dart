import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/portfolio_data.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_media_card.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_header.dart';

class LifestyleSection extends StatefulWidget {
  const LifestyleSection({super.key});

  @override
  State<LifestyleSection> createState() => _LifestyleSectionState();
}

class _LifestyleSectionState extends State<LifestyleSection> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final items = PortfolioData.lifestyleMedia;

    return Container(
      width: double.infinity,
      color: AppTheme.black,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 48 : 24,
        vertical: isWide ? 100 : 64,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RevealOnScroll(
                child: const SectionHeader(
                  label: 'Lifestyle',
                  title: '✨ Life beyond the screen',
                  subtitle:
                      'Team, travel, and the moments that keep me inspired.',
                  dark: true,
                  large: true,
                ),
              ),
              const SizedBox(height: 48),
              if (isWide) _BentoGrid(items: items) else _MobileCarousel(
                items: items,
                pageController: _pageController,
                currentPage: _currentPage,
                onPageChanged: (i) => setState(() => _currentPage = i),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BentoGrid extends StatelessWidget {
  const _BentoGrid({required this.items});

  final List<MediaAsset> items;

  @override
  Widget build(BuildContext context) {
    if (items.length < 4) {
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: items.asMap().entries.map((e) {
          return SizedBox(
            width: 280,
            child: StaggerReveal(
              index: e.key,
              child: AnimatedMediaCard(media: e.value, dark: true),
            ),
          );
        }).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: StaggerReveal(
            index: 0,
            child: AnimatedMediaCard(
              media: items[3],
              dark: true,
              tall: true,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              StaggerReveal(
                index: 1,
                child: AnimatedMediaCard(
                  media: items[2],
                  dark: true,
                ),
              ),
              const SizedBox(height: 20),
              StaggerReveal(
                index: 2,
                child: AnimatedMediaCard(
                  media: items[1],
                  dark: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 3,
          child: StaggerReveal(
            index: 3,
            child: AnimatedMediaCard(
              media: items[0],
              dark: true,
              tall: true,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.06, end: 0);
  }
}

class _MobileCarousel extends StatelessWidget {
  const _MobileCarousel({
    required this.items,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  final List<MediaAsset> items;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: AnimatedMediaCard(
                  media: items[index],
                  dark: true,
                  tall: true,
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(
                      begin: const Offset(0.94, 0.94),
                      end: const Offset(1, 1),
                      curve: Curves.easeOutBack,
                    ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (i) => AnimatedContainer(
              duration: 300.ms,
              width: i == currentPage ? 28 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: i == currentPage ? AppTheme.neon : Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
