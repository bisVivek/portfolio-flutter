import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/portfolio_data.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_header.dart';

/// Ultra-Cool Dark Glassmorphic & Animated Skills Section
class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  String _selectedCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 1100;
    final isMedium = screenWidth >= 700 && screenWidth < 1100;
    final allCategories = PortfolioData.skillCategories;

    final filteredCategories = _selectedCategory == 'ALL'
        ? allCategories
        : allCategories
            .where((cat) =>
                cat.title.toLowerCase() == _selectedCategory.toLowerCase())
            .toList();

    final totalSkillCount = allCategories.fold<int>(
        0, (sum, cat) => sum + cat.skills.length);

    return Container(
      width: double.infinity,
      color: const Color(0xFF09090D),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 48 : (isMedium ? 32 : 20),
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
                  label: 'SKILLS & ARCHITECTURE',
                  title: '💪 Production Tech Stack & Skills',
                  subtitle:
                      'Battle-tested frameworks, state management, backend engines, and DevOps tools.',
                  large: true,
                ),
              ),
              const SizedBox(height: 24),

              // Overview Metric Badges
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MetricBadge(
                    icon: Icons.flash_on_rounded,
                    label: '$totalSkillCount+ Production Skills',
                    accentColor: AppTheme.neon,
                  ),
                  const _MetricBadge(
                    icon: Icons.rocket_launch_rounded,
                    label: '150+ Play Store & 50+ App Store Apps',
                    accentColor: Color(0xFF40C4FF),
                  ),
                  const _MetricBadge(
                    icon: Icons.devices_rounded,
                    label: 'Android, iOS & Wear OS',
                    accentColor: AppTheme.purple,
                  ),
                  const _MetricBadge(
                    icon: Icons.architecture_rounded,
                    label: 'Clean Architecture & MVVM',
                    accentColor: Color(0xFF00E676),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _FilterTab(
                      label: 'ALL (${allCategories.length})',
                      isSelected: _selectedCategory == 'ALL',
                      onTap: () => setState(() => _selectedCategory = 'ALL'),
                    ),
                    ...allCategories.map((cat) {
                      final isSelected = _selectedCategory.toLowerCase() ==
                          cat.title.toLowerCase();
                      return _FilterTab(
                        label: '${cat.title.toUpperCase()} (${cat.skills.length})',
                        isSelected: isSelected,
                        onTap: () =>
                            setState(() => _selectedCategory = cat.title),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Dynamic Skills Layout
              LayoutBuilder(
                builder: (context, constraints) {
                  final columnCount = isWide ? 3 : (isMedium ? 2 : 1);

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: KeyedSubtree(
                      key: ValueKey(_selectedCategory),
                      child: _buildSkillsContent(
                        context: context,
                        filteredCategories: filteredCategories,
                        columnCount: columnCount,
                        isSingleCategory: _selectedCategory != 'ALL',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsContent({
    required BuildContext context,
    required List<SkillCategory> filteredCategories,
    required int columnCount,
    required bool isSingleCategory,
  }) {
    if (isSingleCategory && filteredCategories.isNotEmpty) {
      final cat = filteredCategories.first;
      final catIndex = PortfolioData.skillCategories.indexWhere(
        (c) => c.title.toLowerCase() == cat.title.toLowerCase(),
      );
      return _SpotlightSkillCategoryCard(
        category: cat,
        cardIndex: catIndex >= 0 ? catIndex : 0,
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: columnCount == 3
            ? 1.28
            : (columnCount == 2 ? 1.38 : 1.55),
      ),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) => StaggerReveal(
        index: index,
        child: _MasterpieceSkillCard(
          category: filteredCategories[index],
          highlighted: index == 0 && _selectedCategory == 'ALL',
          cardIndex: index,
        ),
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({
    required this.icon,
    required this.label,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: accentColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.white.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.neon
                : AppTheme.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? AppTheme.neon
                  : AppTheme.white.withValues(alpha: 0.15),
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppTheme.neon.withValues(alpha: 0.35),
                  blurRadius: 14,
                ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.black : AppTheme.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

/// Full Spotlight Layout when a specific Category is filtered
class _SpotlightSkillCategoryCard extends StatefulWidget {
  const _SpotlightSkillCategoryCard({
    required this.category,
    required this.cardIndex,
  });

  final SkillCategory category;
  final int cardIndex;

  @override
  State<_SpotlightSkillCategoryCard> createState() =>
      _SpotlightSkillCategoryCardState();
}

class _SpotlightSkillCategoryCardState
    extends State<_SpotlightSkillCategoryCard> {
  int _proficiencyFor(String title) {
    return switch (title.toLowerCase()) {
      'core' => 98,
      'state management' => 95,
      'backend & languages' => 90,
      'integrations' => 94,
      'deployment' => 96,
      'tools' => 92,
      _ => 90,
    };
  }

  Color _accentFor(String title) {
    return switch (title.toLowerCase()) {
      'core' => const Color(0xFF40C4FF),
      'state management' => AppTheme.neon,
      'backend & languages' => const Color(0xFFFF9800),
      'integrations' => const Color(0xFFFFCA28),
      'deployment' => AppTheme.purple,
      'tools' => const Color(0xFF00E676),
      _ => AppTheme.neon,
    };
  }

  String _descriptionFor(String title) {
    return switch (title.toLowerCase()) {
      'core' =>
        'Primary framework expertise in cross-platform mobile development (Android, iOS & Wear OS) using Flutter & Dart.',
      'state management' =>
        'Scalable state management patterns ensuring predictable data flow, modular code separation, and high app performance.',
      'backend & languages' =>
        'Robust backend integration and server-side Java/Spring Boot & RESTful APIs powering cloud functionalities.',
      'integrations' =>
        'Third-party SDK integrations including payment gateways, real-time messaging, telephony, maps, and audio/video calling.',
      'deployment' =>
        'End-to-end production release workflow managing 150+ Google Play Store apps and 50+ Apple App Store apps.',
      'tools' =>
        'DevOps, version control, API testing, and IDE toolchains powering efficient everyday development.',
      _ => 'Key tech stack components built and battle-tested in production.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final proficiency = _proficiencyFor(category.title);
    final accent = _accentFor(category.title);
    final description = _descriptionFor(category.title);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E16),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accent.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.15),
            blurRadius: 30,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Spotlight Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accent.withValues(alpha: 0.5),
                  ),
                ),
                child: _leadingIconFor(category.title, accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          category.title.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 1.2,
                            color: AppTheme.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: accent.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            '${category.skills.length} Items',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.white.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress Bar
          Row(
            children: [
              Text(
                'Proficiency Metric',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: proficiency / 100.0,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(accent),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$proficiency%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Skill Chips Wrap
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: category.skills.asMap().entries.map((entry) {
              final skillIndex = entry.key;
              final skill = entry.value;
              return _CyberSkillPill(
                skill: skill,
                accentColor: accent,
                delayMs: (widget.cardIndex * 50) + (skillIndex * 30),
                isLarge: true,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _leadingIconFor(String title, Color accent) {
    return switch (title.toLowerCase()) {
      'core' => const FlutterLogo(size: 24),
      'state management' => Icon(Icons.hub_rounded, color: accent, size: 24),
      'backend & languages' => const _JavaCoffeeLogo(size: 24),
      'integrations' => Icon(Icons.extension_rounded, color: accent, size: 24),
      'deployment' => Icon(Icons.rocket_launch_rounded, color: accent, size: 24),
      'tools' => Icon(Icons.build_circle_rounded, color: accent, size: 24),
      _ => Icon(Icons.code_rounded, color: accent, size: 24),
    };
  }
}

class _MasterpieceSkillCard extends StatefulWidget {
  const _MasterpieceSkillCard({
    required this.category,
    this.highlighted = false,
    required this.cardIndex,
  });

  final SkillCategory category;
  final bool highlighted;
  final int cardIndex;

  @override
  State<_MasterpieceSkillCard> createState() => _MasterpieceSkillCardState();
}

class _MasterpieceSkillCardState extends State<_MasterpieceSkillCard> {
  bool _hovered = false;

  int _proficiencyFor(String title) {
    return switch (title.toLowerCase()) {
      'core' => 98,
      'state management' => 95,
      'backend & languages' => 90,
      'integrations' => 94,
      'deployment' => 96,
      'tools' => 92,
      _ => 90,
    };
  }

  Color _accentFor(String title) {
    return switch (title.toLowerCase()) {
      'core' => const Color(0xFF40C4FF),
      'state management' => AppTheme.neon,
      'backend & languages' => const Color(0xFFFF9800),
      'integrations' => const Color(0xFFFFCA28),
      'deployment' => AppTheme.purple,
      'tools' => const Color(0xFF00E676),
      _ => AppTheme.neon,
    };
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final proficiency = _proficiencyFor(category.title);
    final accent = _accentFor(category.title);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF14141E)
                : const Color(0xFF0E0E16),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? accent
                  : accent.withValues(alpha: 0.3),
              width: _hovered ? 1.6 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? accent.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.4),
                blurRadius: _hovered ? 20 : 10,
                spreadRadius: _hovered ? 1 : 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accent.withValues(alpha: 0.5),
                      ),
                    ),
                    child: _leadingIconFor(category.title, accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 1.0,
                            color: AppTheme.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: proficiency / 100.0,
                                  minHeight: 5,
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.1),
                                  valueColor: AlwaysStoppedAnimation(accent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$proficiency%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Skill Chips Grid (Fills tight without scrolling or empty gaps)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: category.skills.asMap().entries.map((entry) {
                  final skillIndex = entry.key;
                  final skill = entry.value;
                  return _CyberSkillPill(
                    skill: skill,
                    accentColor: accent,
                    delayMs: (widget.cardIndex * 40) + (skillIndex * 25),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leadingIconFor(String title, Color accent) {
    return switch (title.toLowerCase()) {
      'core' => const FlutterLogo(size: 20),
      'state management' => Icon(Icons.hub_rounded, color: accent, size: 20),
      'backend & languages' => const _JavaCoffeeLogo(size: 20),
      'integrations' => Icon(Icons.extension_rounded, color: accent, size: 20),
      'deployment' => Icon(Icons.rocket_launch_rounded, color: accent, size: 20),
      'tools' => Icon(Icons.build_circle_rounded, color: accent, size: 20),
      _ => Icon(Icons.code_rounded, color: accent, size: 20),
    };
  }
}

class _CyberSkillPill extends StatefulWidget {
  const _CyberSkillPill({
    required this.skill,
    required this.accentColor,
    required this.delayMs,
    this.isLarge = false,
  });

  final String skill;
  final Color accentColor;
  final int delayMs;
  final bool isLarge;

  @override
  State<_CyberSkillPill> createState() => _CyberSkillPillState();
}

class _CyberSkillPillState extends State<_CyberSkillPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor;
    final padding = widget.isLarge
        ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: padding,
        decoration: BoxDecoration(
          color: _hovered
              ? accent.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered
                ? accent
                : Colors.white.withValues(alpha: 0.12),
          ),
          boxShadow: [
            if (_hovered)
              BoxShadow(
                color: accent.withValues(alpha: 0.35),
                blurRadius: 8,
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _skillLogoFor(widget.skill, accent),
            const SizedBox(width: 6),
            Text(
              widget.skill,
              style: TextStyle(
                fontSize: widget.isLarge ? 13 : 11,
                fontWeight: FontWeight.w700,
                color: _hovered
                    ? AppTheme.white
                    : AppTheme.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: widget.delayMs))
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          delay: Duration(milliseconds: widget.delayMs),
        );
  }

  Widget _skillLogoFor(String skill, Color defaultColor) {
    final name = skill.toLowerCase();
    final iconSize = widget.isLarge ? 15.0 : 13.0;

    if (name.contains('flutter')) {
      return FlutterLogo(size: iconSize);
    } else if (name.contains('firebase')) {
      return _FirebaseFlameLogo(size: iconSize);
    } else if (name.contains('java') && !name.contains('javascript')) {
      return _JavaCoffeeLogo(size: iconSize);
    } else if (name.contains('spring')) {
      return _SpringBootLogo(size: iconSize);
    } else if (name.contains('android') || name.contains('ios') || name.contains('wear')) {
      return Icon(Icons.phone_android, color: const Color(0xFF3DDC84), size: iconSize);
    } else if (name.contains('ci/cd') || name.contains('fastlane') || name.contains('pipeline')) {
      return Icon(Icons.sync_alt_rounded, color: AppTheme.neon, size: iconSize);
    } else if (name.contains('git')) {
      return Icon(Icons.merge_type_rounded, color: const Color(0xFFF05032), size: iconSize);
    } else {
      return Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: defaultColor,
          shape: BoxShape.circle,
        ),
      );
    }
  }
}

/// Official 3D-styled Firebase Flame Logo Painter
class _FirebaseFlameLogo extends StatelessWidget {
  const _FirebaseFlameLogo({this.size = 16});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FirebaseFlamePainter(),
      ),
    );
  }
}

class _FirebaseFlamePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path1 = Path()
      ..moveTo(w * 0.12, h * 0.78)
      ..lineTo(w * 0.48, h * 0.08)
      ..lineTo(w * 0.68, h * 0.48)
      ..close();
    canvas.drawPath(path1, Paint()..color = const Color(0xFFFFA000));

    final path2 = Path()
      ..moveTo(w * 0.88, h * 0.78)
      ..lineTo(w * 0.48, h * 0.08)
      ..lineTo(w * 0.68, h * 0.48)
      ..close();
    canvas.drawPath(path2, Paint()..color = const Color(0xFFFFCA28));

    final path3 = Path()
      ..moveTo(w * 0.12, h * 0.78)
      ..lineTo(w * 0.5, h * 0.94)
      ..lineTo(w * 0.88, h * 0.78)
      ..lineTo(w * 0.58, h * 0.32)
      ..close();
    canvas.drawPath(path3, Paint()..color = const Color(0xFFF57C00));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Official Java Coffee Cup Logo Painter
class _JavaCoffeeLogo extends StatelessWidget {
  const _JavaCoffeeLogo({this.size = 16});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _JavaCoffeePainter(),
      ),
    );
  }
}

class _JavaCoffeePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final cupPath = Path()
      ..moveTo(w * 0.2, h * 0.45)
      ..lineTo(w * 0.25, h * 0.85)
      ..cubicTo(w * 0.3, h * 0.95, w * 0.7, h * 0.95, w * 0.75, h * 0.85)
      ..lineTo(w * 0.8, h * 0.45)
      ..close();
    canvas.drawPath(cupPath, Paint()..color = const Color(0xFFE76F00));

    final steamPath = Path()
      ..moveTo(w * 0.4, h * 0.35)
      ..quadraticBezierTo(w * 0.3, h * 0.2, w * 0.4, h * 0.05)
      ..moveTo(w * 0.6, h * 0.35)
      ..quadraticBezierTo(w * 0.5, h * 0.2, w * 0.6, h * 0.05);
    canvas.drawPath(
      steamPath,
      Paint()
        ..color = const Color(0xFFD9381E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Official Spring Boot Green Leaf Logo Painter
class _SpringBootLogo extends StatelessWidget {
  const _SpringBootLogo({this.size = 16});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SpringBootPainter(),
      ),
    );
  }
}

class _SpringBootPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final leafPath = Path()
      ..moveTo(w * 0.1, h * 0.85)
      ..cubicTo(w * 0.05, h * 0.3, w * 0.5, h * 0.05, w * 0.9, h * 0.1)
      ..cubicTo(w * 0.95, h * 0.7, w * 0.5, h * 0.95, w * 0.1, h * 0.85)
      ..close();
    canvas.drawPath(
      leafPath,
      Paint()..color = const Color(0xFF6DB33F),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
