import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/experience_card.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_header.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

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
                  label: 'Experience',
                  title: '🏆 Where I have worked',
                  dark: true,
                  large: true,
                ),
              ),
              const SizedBox(height: 48),
              ...PortfolioData.experiences.asMap().entries.map(
                    (entry) => StaggerReveal(
                      index: entry.key,
                      child: ExperienceCard(
                        experience: entry.value,
                        dark: true,
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
