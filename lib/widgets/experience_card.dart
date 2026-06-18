import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({
    super.key,
    required this.experience,
    this.dark = false,
  });

  final Experience experience;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final titleColor = AppTheme.onSection(dark);
    final subColor = AppTheme.onSectionMuted(dark);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '+',
            style: TextStyle(
              color: AppTheme.neon,
              fontSize: 28,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experience.company,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${experience.title} · ${experience.period}',
                  style: TextStyle(color: subColor, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ...experience.highlights.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: subColor,
                        height: 1.55,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
