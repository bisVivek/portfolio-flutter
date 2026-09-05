import 'dart:async';
import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/project_card.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_header.dart';
import '../widgets/work_showcase.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  late final PageController _projectsPageController;
  int _currentProjectPage = 0;
  Timer? _autoPlayTimer;

  final List<(String, int)> _categories = const [
    ('All Projects (5)', 0),
    ('Food & Grocery (2)', 0),
    ('Delivery Partner (1)', 2),
    ('Wear OS (1)', 3),
    ('RTC & Audio/Video (1)', 4),
  ];

  @override
  void initState() {
    super.initState();
    _projectsPageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (PortfolioData.projects.length <= 1) return;
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!mounted) return;
      final total = PortfolioData.projects.length;
      final nextPage = (_currentProjectPage + 1) % total;
      _projectsPageController.animateToPage(
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
    setState(() => _currentProjectPage = index);
  }

  void _nextPage() {
    final total = PortfolioData.projects.length;
    final next = (_currentProjectPage + 1) % total;
    _projectsPageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
    _resetAutoPlay();
  }

  void _previousPage() {
    final total = PortfolioData.projects.length;
    final prev = (_currentProjectPage - 1 + total) % total;
    _projectsPageController.animateToPage(
      prev,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
    _resetAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _projectsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final projects = PortfolioData.projects;

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
                child: const SectionHeader(
                  label: 'Work',
                  title: '🚀 Explore my work',
                  subtitle:
                      'Production apps shipped to Play Store, App Store, and Web.',
                  large: true,
                ),
              ),
              const SizedBox(height: 48),
              const WorkShowcase(),
              const SizedBox(height: 56),

              // ALL PROJECTS Header Row with Navigation Controls
              RevealOnScroll(
                child: isWide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppTheme.purple,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'ALL PROJECTS',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                  fontSize: 12,
                                  color: AppTheme.purple,
                                ),
                              ),
                            ],
                          ),
                          _buildSliderControls(projects.length),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: AppTheme.purple,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'ALL PROJECTS',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2,
                                      fontSize: 12,
                                      color: AppTheme.purple,
                                    ),
                                  ),
                                ],
                              ),
                              _buildSliderControls(projects.length),
                            ],
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 20),

              // Quick Category Filter Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _categories.map((cat) {
                    final targetPage = cat.$2;
                    final isSelected = _currentProjectPage == targetPage;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          _projectsPageController.animateToPage(
                            targetPage,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                          );
                          _resetAutoPlay();
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.black
                                : AppTheme.backgroundAlt,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.black
                                  : AppTheme.border,
                            ),
                          ),
                          child: Text(
                            cat.$1,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Slidable Projects PageView
              SizedBox(
                height: isWide ? 490 : 680,
                child: PageView.builder(
                  controller: _projectsPageController,
                  onPageChanged: _onPageChanged,
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ProjectCard(
                        project: projects[index],
                        index: index,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Bottom Indicator Dots
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(projects.length, (i) {
                    final isSelected = i == _currentProjectPage;
                    return InkWell(
                      onTap: () {
                        _projectsPageController.animateToPage(
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
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isSelected ? 32 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.purple
                              : AppTheme.border,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppTheme.purple.withValues(alpha: 0.4),
                                    blurRadius: 6,
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

  Widget _buildSliderControls(int total) {
    final pageStr = '0${_currentProjectPage + 1} / 0$total';

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
          ),
          const SizedBox(width: 6),
          _CircleNavButton(
            icon: Icons.chevron_right_rounded,
            onTap: _nextPage,
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
  });

  final IconData icon;
  final VoidCallback onTap;

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


