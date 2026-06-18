import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    this.subtitle,
    this.large = false,
    this.dark = false,
  });

  final String label;
  final String title;
  final String? subtitle;
  final bool large;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final titleColor = AppTheme.onSection(dark);
    final subColor = AppTheme.onSectionMuted(dark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: dark ? AppTheme.neon : AppTheme.purple,
              ),
        ),
        SizedBox(height: large ? 20 : 12),
        Text(
          title,
          style: (large
                  ? Theme.of(context).textTheme.displayMedium
                  : Theme.of(context).textTheme.headlineMedium)
              ?.copyWith(color: titleColor),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: subColor,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
