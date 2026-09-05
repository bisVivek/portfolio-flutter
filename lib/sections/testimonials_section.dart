import 'dart:async';
import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_header.dart';
import '../widgets/testimonial_card.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (PortfolioData.testimonials.length <= 1) return;
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted) return;
      final total = PortfolioData.testimonials.length;
      final nextPage = (_currentPage + 1) % total;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _resetAutoPlay() {
    _startAutoPlay();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _nextPage() {
    final total = PortfolioData.testimonials.length;
    final next = (_currentPage + 1) % total;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
    _resetAutoPlay();
  }

  void _previousPage() {
    final total = PortfolioData.testimonials.length;
    final prev = (_currentPage - 1 + total) % total;
    _pageController.animateToPage(
      prev,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
    _resetAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final testimonials = PortfolioData.testimonials;
    final currentAccent = testimonials[_currentPage].accentColor;

    return Container(
      width: double.infinity,
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 48 : 20,
        vertical: isWide ? 90 : 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RevealOnScroll(
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Expanded(
                            child: SectionHeader(
                              label: 'Testimonials',
                              title: '💬 What clients say',
                              subtitle:
                                  'Production apps shipped and trusted by real businesses.',
                              large: true,
                            ),
                          ),
                          _buildSliderControls(
                            testimonials.length,
                            currentAccent,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(
                            label: 'Testimonials',
                            title: '💬 What clients say',
                            subtitle:
                                'Production apps shipped and trusted by real businesses.',
                            large: true,
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _buildSliderControls(
                              testimonials.length,
                              currentAccent,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 40),

              // Slidable PageView
              SizedBox(
                height: isWide ? 480 : 680,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: testimonials.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TestimonialCard(
                        testimonial: testimonials[index],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // Bottom Page Indicator Bar
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(testimonials.length, (i) {
                    final isSelected = i == _currentPage;
                    final accent = testimonials[i].accentColor;
                    return InkWell(
                      onTap: () {
                        _pageController.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic,
                        );
                        _resetAutoPlay();
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: isSelected ? 36 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isSelected ? accent : AppTheme.border,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: accent.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderControls(int total, Color activeAccent) {
    final pageStr = '0${_currentPage + 1} / 0$total';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            pageStr,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 1,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 16,
            color: AppTheme.border,
          ),
          const SizedBox(width: 8),
          _CircleNavButton(
            icon: Icons.chevron_left_rounded,
            onTap: _previousPage,
            accentColor: activeAccent,
          ),
          const SizedBox(width: 6),
          _CircleNavButton(
            icon: Icons.chevron_right_rounded,
            onTap: _nextPage,
            accentColor: activeAccent,
          ),
        ],
      ),
    );
  }
}

class _CircleNavButton extends StatelessWidget {
  const _CircleNavButton({
    required this.icon,
    required this.onTap,
    required this.accentColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        hoverColor: accentColor.withValues(alpha: 0.15),
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

