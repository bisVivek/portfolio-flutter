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
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final allCategories = PortfolioData.skillCategories;

    final filteredCategories = _selectedCategory == 'ALL'
        ? allCategories
        : allCategories
            .where((cat) =>
                cat.title.toLowerCase() == _selectedCategory.toLowerCase())
            .toList();

    return Container(
      width: double.infinity,
      color: const Color(0xFF09090D),
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
                  label: 'SKILLS & ARCHITECTURE',
                  title: '💪 Production Tech Stack & Skills',
                  subtitle:
                      'Battle-tested frameworks, state management, backend engines, and DevOps tools.',
                  large: true,
                ),
              ),
              const SizedBox(height: 36),

              // Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _FilterTab(
                      label: 'ALL',
                      isSelected: _selectedCategory == 'ALL',
                      onTap: () => setState(() => _selectedCategory = 'ALL'),
                    ),
                    ...allCategories.map((cat) {
                      final isSelected = _selectedCategory.toLowerCase() ==
                          cat.title.toLowerCase();
                      return _FilterTab(
                        label: cat.title.toUpperCase(),
                        isSelected: isSelected,
                        onTap: () =>
                            setState(() => _selectedCategory = cat.title),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Skills Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 3 : 1,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: isWide ? 1.05 : 1.25,
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
                },
              ),
            ],
          ),
        ),
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
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
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
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF14141E)
                : const Color(0xFF0E0E16),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _hovered
                  ? accent
                  : accent.withValues(alpha: 0.3),
              width: _hovered ? 1.8 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? accent.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.4),
                blurRadius: _hovered ? 24 : 12,
                spreadRadius: _hovered ? 1 : 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accent.withValues(alpha: 0.5),
                      ),
                    ),
                    child: _leadingIconFor(category.title, accent),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            letterSpacing: 1.1,
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
              const SizedBox(height: 18),

              // Skill Chips Grid
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: category.skills.asMap().entries.map((entry) {
                      final skillIndex = entry.key;
                      final skill = entry.value;
                      return _CyberSkillPill(
                        skill: skill,
                        accentColor: accent,
                        delayMs: (widget.cardIndex * 70) + (skillIndex * 40),
                      );
                    }).toList(),
                  ),
                ),
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
  });

  final String skill;
  final Color accentColor;
  final int delayMs;

  @override
  State<_CyberSkillPill> createState() => _CyberSkillPillState();
}

class _CyberSkillPillState extends State<_CyberSkillPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _hovered
              ? accent.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered
                ? accent
                : Colors.white.withValues(alpha: 0.12),
          ),
          boxShadow: [
            if (_hovered)
              BoxShadow(
                color: accent.withValues(alpha: 0.35),
                blurRadius: 10,
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _skillLogoFor(widget.skill, accent),
            const SizedBox(width: 8),
            Text(
              widget.skill,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _hovered ? AppTheme.white : AppTheme.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: Duration(milliseconds: widget.delayMs))
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1.0, 1.0),
          duration: 500.ms,
          delay: Duration(milliseconds: widget.delayMs),
        );
  }

  Widget _skillLogoFor(String skill, Color defaultColor) {
    final name = skill.toLowerCase();
    if (name.contains('flutter')) {
      return const FlutterLogo(size: 14);
    } else if (name.contains('firebase')) {
      return const _FirebaseFlameLogo(size: 14);
    } else if (name.contains('java') && !name.contains('javascript')) {
      return const _JavaCoffeeLogo(size: 14);
    } else if (name.contains('spring')) {
      return const _SpringBootLogo(size: 14);
    } else if (name.contains('android') || name.contains('ios')) {
      return const Icon(Icons.phone_android, color: Color(0xFF3DDC84), size: 14);
    } else if (name.contains('ci/cd')) {
      return const Icon(Icons.sync_alt_rounded, color: AppTheme.neon, size: 14);
    } else if (name.contains('git')) {
      return const Icon(Icons.merge_type_rounded, color: Color(0xFFF05032), size: 14);
    } else {
      return Container(
        width: 6,
        height: 6,
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

    // Coffee Cup Body
    final cupPath = Path()
      ..moveTo(w * 0.2, h * 0.45)
      ..lineTo(w * 0.25, h * 0.85)
      ..cubicTo(w * 0.3, h * 0.95, w * 0.7, h * 0.95, w * 0.75, h * 0.85)
      ..lineTo(w * 0.8, h * 0.45)
      ..close();
    canvas.drawPath(cupPath, Paint()..color = const Color(0xFFE76F00));

    // Cup Steam
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
