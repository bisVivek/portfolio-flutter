import 'dart:async';
import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/project_card.dart';
import '../widgets/reveal_on_scroll.dart';
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
  bool _isHovered = false;
  int? _hoveredStripIndex;

  final List<(String, int)> _categories = const [
    ('ALL 05', 0),
    ('FOOD & GROCERY 02', 0),
    ('DELIVERY 01', 2),
    ('WEAR OS 01', 3),
    ('RTC & A/V 01', 4),
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
      if (!mounted || _isHovered) return;
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
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 48 : 16,
        vertical: isWide ? 90 : 36,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // OPENING EXPERIENCE — "THE PROJECT UNIVERSE"
              // ==================================================
              RevealOnScroll(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small Text Label
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.purple.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppTheme.purple.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome,
                              size: 13, color: AppTheme.purple),
                          SizedBox(width: 6),
                          Text(
                            'SELECTED WORK',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.5,
                              fontSize: 11,
                              color: AppTheme.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Huge Typography Reveal: "BUILT. SHIPPED. USED."
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF090914), Color(0xFF2A1C52), Color(0xFF6B46C1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'BUILT.\nSHIPPED.\nUSED.',
                        style: TextStyle(
                          fontSize: isWide ? 64 : 40,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                          letterSpacing: -2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle below it
                    Text(
                      '"Real products. Real users. Real production."',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: isWide ? 20 : 16,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Thin animated glowing line underneath
                    Container(
                      height: 3,
                      width: isWide ? 220 : 140,
                      decoration: BoxDecoration(
                        gradient: AppTheme.brandGradient,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.purple.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isWide ? 56 : 28),

              // ==================================================
              // SECTION 02 — LIVE IN PRODUCTION (PROJECT STRIP)
              // ==================================================
              RevealOnScroll(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LIVE IN PRODUCTION',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        fontSize: 11,
                        color: AppTheme.purple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: projects.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final proj = entry.value;
                          final isHovered = _hoveredStripIndex == idx;
                          final isSelected = _currentProjectPage == idx;

                          return Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: MouseRegion(
                              onEnter: (_) =>
                                  setState(() => _hoveredStripIndex = idx),
                              onExit: (_) =>
                                  setState(() => _hoveredStripIndex = null),
                              child: InkWell(
                                onTap: () {
                                  _projectsPageController.animateToPage(
                                    idx,
                                    duration:
                                        const Duration(milliseconds: 500),
                                    curve: Curves.easeInOutCubic,
                                  );
                                  _resetAutoPlay();
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  transform: Matrix4.identity()
                                    // ignore: deprecated_member_use
                                    ..scale(isHovered ? 1.04 : 1.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.black
                                        : (isHovered
                                            ? AppTheme.backgroundAlt
                                            : Colors.white),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.purple
                                          : (isHovered
                                              ? AppTheme.purple
                                                  .withValues(alpha: 0.4)
                                              : AppTheme.border),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: [
                                      if (isSelected || isHovered)
                                        BoxShadow(
                                          color: AppTheme.purple
                                              .withValues(alpha: 0.2),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6),
                                        ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppTheme.purple
                                              : AppTheme.purple
                                                  .withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _iconForProjectName(proj.name),
                                          size: 16,
                                          color: isSelected
                                              ? Colors.white
                                              : AppTheme.purple,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            proj.name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppTheme.black,
                                            ),
                                          ),
                                          Text(
                                            proj.techStack.take(2).join(' · '),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: isSelected
                                                  ? Colors.white70
                                                  : AppTheme.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isWide ? 64 : 28),

              // ==================================================
              // SECTION 03 — APP DEMOS (3D SMARTPHONE SHOWCASE)
              // ==================================================
              const WorkShowcase(),
              SizedBox(height: isWide ? 64 : 28),

              // ==================================================
              // SECTION 04 — PROJECT SLIDER (ONE-BY-ONE CAROUSEL)
              // ==================================================
              MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Category Navigation Tabs Bar
                    RevealOnScroll(
                      child: isWide
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildCategoryTabs(),
                                _buildSliderControls(projects.length),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'PROJECT SLIDER',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.5,
                                        fontSize: 12,
                                        color: AppTheme.purple,
                                      ),
                                    ),
                                    _buildSliderControls(projects.length),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                _buildCategoryTabs(),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Slidable Projects PageView Container with Right-Side Vertical Navigator
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: isWide ? 510 : 536,
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
                        ),
                        if (isWide) ...[
                          const SizedBox(width: 20),
                          _buildVerticalProjectNavigator(),
                        ],
                      ],
                    ),

                    SizedBox(height: isWide ? 32 : 14),

                    // ==================================================
                    // BOTTOM NAVIGATION & PROGRESS INDICATOR
                    // 01 ━━━━━━━━━━━━━━━━━━━━━ 05
                    // ==================================================
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundAlt,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '01',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color: AppTheme.black,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(projects.length, (i) {
                                final isSelected = i == _currentProjectPage;
                                return InkWell(
                                  onTap: () {
                                    _projectsPageController.animateToPage(
                                      i,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOutCubic,
                                    );
                                    _resetAutoPlay();
                                  },
                                  borderRadius: BorderRadius.circular(999),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCubic,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    width: isSelected ? 36 : 10,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.purple
                                          : AppTheme.border,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppTheme.purple
                                                    .withValues(alpha: 0.5),
                                                blurRadius: 10,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              '05',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color: AppTheme.black,
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
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.black : AppTheme.backgroundAlt,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected ? AppTheme.black : AppTheme.border,
                  ),
                ),
                child: Text(
                  cat.$1,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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

  Widget _buildVerticalProjectNavigator() {
    final navItems = const [
      ('01', 'ERIZO'),
      ('02', 'ZOFANSO'),
      ('03', 'DELIVERY'),
      ('04', 'PADEL'),
      ('05', 'ASTROLOGY'),
    ];

    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Thin Vertical Progress Line
          Positioned(
            left: 11,
            top: 14,
            bottom: 14,
            child: Container(
              width: 2,
              color: AppTheme.border,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: navItems.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              final isActive = idx == _currentProjectPage;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () {
                    _projectsPageController.animateToPage(
                      idx,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic,
                    );
                    _resetAutoPlay();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.black
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive
                            ? AppTheme.purple
                            : Colors.transparent,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppTheme.purple.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isActive ? 8 : 6,
                          height: isActive ? 8 : 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? AppTheme.neon : AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.$1,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: isActive ? AppTheme.neon : AppTheme.textMuted,
                                ),
                              ),
                              Text(
                                item.$2,
                                style: TextStyle(
                                  fontSize: isActive ? 12 : 11,
                                  fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                                  letterSpacing: isActive ? 1.5 : 0.5,
                                  color: isActive ? Colors.white : AppTheme.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _iconForProjectName(String name) {
    return switch (name.toLowerCase()) {
      'zofanso' => Icons.delivery_dining_rounded,
      'erizo' || 'erizo delivery' => Icons.shopping_bag_rounded,
      'padel magic' => Icons.watch_rounded,
      'astrology' => Icons.self_improvement_rounded,
      _ => Icons.phone_android_rounded,
    };
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



