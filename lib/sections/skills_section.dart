import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_header.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final categories = PortfolioData.skillCategories;

    return Container(
      width: double.infinity,
      color: AppTheme.white,
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
                  label: 'Skills',
                  title: '💪 What I bring to the table',
                  subtitle:
                      'Technologies and tools I use to ship production-ready apps.',
                  large: true,
                ),
              ),
              const SizedBox(height: 48),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 3 : 1,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: isWide ? 1.3 : 1.6,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) => StaggerReveal(
                  index: index,
                  child: _SkillCard(
                    category: categories[index],
                    highlighted: index == 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.category, this.highlighted = false});

  final SkillCategory category;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final bg = highlighted ? AppTheme.neon : AppTheme.white;
    final fg = highlighted ? AppTheme.black : AppTheme.black;
    final subFg = highlighted ? AppTheme.black.withValues(alpha: 0.7) : AppTheme.textMuted;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted ? AppTheme.neon : AppTheme.border,
          width: highlighted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _iconFor(category.title),
            color: highlighted ? AppTheme.black : AppTheme.purple,
            size: 28,
          ),
          const SizedBox(height: 16),
          Text(
            category.title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              letterSpacing: 1,
              color: fg,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              category.skills.join(' · '),
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: subFg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String title) {
    return switch (title.toLowerCase()) {
      'core' => Icons.phone_android_outlined,
      'state management' => Icons.hub_outlined,
      'integrations' => Icons.extension_outlined,
      'deployment' => Icons.rocket_launch_outlined,
      'tools' => Icons.build_outlined,
      _ => Icons.code_outlined,
    };
  }
}
