import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import '../utils/url_helper.dart';
import '../widgets/gradient_accent_bar.dart';
import '../widgets/hover_card.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, this.index = 0});

  final Project project;
  final int index;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(bottom: 32),
        decoration: AppTheme.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GradientAccentBar(),
            const SizedBox(height: 20),
          Text(
            project.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 26,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.purple.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              project.techStack.join('  ·  ').toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppTheme.purple,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: project.coverImage != null
                ? Image.asset(
                    project.coverImage!,
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallbackVisual(),
                  )
                : _buildFallbackVisual(),
          ),
          if (_hasLinks) ...[
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (project.websiteUrl != null)
                  _LinkChip(
                    label: 'Website',
                    onTap: () => launchExternalUrl(project.websiteUrl!),
                  ),
                if (project.playStoreUrl != null)
                  _LinkChip(
                    label: 'Play Store',
                    onTap: () => launchExternalUrl(project.playStoreUrl!),
                  ),
                if (project.appStoreUrl != null)
                  _LinkChip(
                    label: 'App Store',
                    onTap: () => launchExternalUrl(project.appStoreUrl!),
                  ),
              ],
            ),
          ],
          ],
        ),
      ),
    );
  }

  bool get _hasLinks =>
      project.websiteUrl != null ||
      project.playStoreUrl != null ||
      project.appStoreUrl != null;

  Widget _buildFallbackVisual() {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            _iconForProject(project.name),
            color: Colors.white.withValues(alpha: 0.9),
            size: 36,
          ),
          ...project.highlights.take(2).map(
                (h) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    h,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  IconData _iconForProject(String name) {
    return switch (name.toLowerCase()) {
      'zofanso' => Icons.delivery_dining_outlined,
      'erizo' || 'erizo delivery' => Icons.shopping_bag_outlined,
      'padel magic' => Icons.watch_outlined,
      _ => Icons.phone_android_outlined,
    };
  }
}

class _LinkChip extends StatelessWidget {
  const _LinkChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.neon,
          border: Border.all(color: AppTheme.neon),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.black,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_outward, size: 14),
          ],
        ),
      ),
    );
  }
}
