import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientAccentBar extends StatelessWidget {
  const GradientAccentBar({super.key, this.height = 4});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.neon,
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}
