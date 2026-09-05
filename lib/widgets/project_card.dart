import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import '../utils/url_helper.dart';
import '../widgets/hover_card.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, this.index = 0});

  final Project project;
  final int index;

  static const List<Color> _accents = [
    Color(0xFF7B61FF), // Purple
    Color(0xFFC1FF00), // Neon Lime
    Color(0xFF00E5FF), // Electric Cyan
    Color(0xFFFF6D00), // Vivid Orange
    Color(0xFFE91E63), // Pink
  ];

  Color get _accent => _accents[index % _accents.length];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return HoverCard(
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: _accent.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Top glowing accent indicator bar
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _accent,
                    _accent.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isWide ? 36 : 20),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: _buildDetails(context),
                            ),
                          ),
                          const SizedBox(width: 36),
                          Expanded(
                            flex: 4,
                            child: _buildMediaVisual(),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMediaVisual(height: 220),
                            const SizedBox(height: 20),
                            _buildDetails(context),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Badges Row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: _accent.withValues(alpha: 0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'PROJECT 0${index + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: _accent == AppTheme.neon ? AppTheme.black : _accent,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (project.playStoreUrl != null || project.websiteUrl != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundAlt,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, size: 13, color: Color(0xFF00C853)),
                    SizedBox(width: 4),
                    Text(
                      'Live Shipped',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // Title
        Text(
          project.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 10),

        // Description
        Text(
          project.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 15,
                height: 1.55,
                color: AppTheme.textSecondary,
              ),
        ),
        const SizedBox(height: 18),

        // Tech Stack Pills (Individual Hashtag Chips)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.techStack.map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.backgroundAlt,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                '#$tech',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            );
          }).toList(),
        ),

        // Highlights Bullet Points
        if (project.highlights.isNotEmpty) ...[
          const SizedBox(height: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: project.highlights.map((h) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 12,
                        color: _accent == AppTheme.neon ? AppTheme.black : _accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        h,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],

        // Action Link Buttons
        if (_hasLinks) ...[
          const SizedBox(height: 22),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (project.websiteUrl != null)
                _LinkButton(
                  label: 'Website',
                  icon: Icons.language_rounded,
                  accentColor: _accent,
                  onTap: () => launchExternalUrl(project.websiteUrl!),
                ),
              if (project.playStoreUrl != null)
                _LinkButton(
                  label: 'Play Store',
                  icon: Icons.android_rounded,
                  accentColor: _accent,
                  onTap: () => launchExternalUrl(project.playStoreUrl!),
                ),
              if (project.appStoreUrl != null)
                _LinkButton(
                  label: 'App Store',
                  icon: Icons.apple_rounded,
                  accentColor: _accent,
                  onTap: () => launchExternalUrl(project.appStoreUrl!),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMediaVisual({double? height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height ?? double.infinity,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            project.coverImage != null
                ? Image.asset(
                    project.coverImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallbackVisual(),
                  )
                : _buildFallbackVisual(),
            if (project.coverImage != null) ...[
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.crop_original_rounded, size: 14, color: _accent),
                      const SizedBox(width: 6),
                      Text(
                        project.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
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
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.black,
            const Color(0xFF1E1E2E),
            _accent.withValues(alpha: 0.35),
          ],
        ),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(
              _iconForProject(project.name),
              color: _accent,
              size: 38,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            project.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForProject(String name) {
    return switch (name.toLowerCase()) {
      'zofanso' => Icons.delivery_dining_rounded,
      'erizo' || 'erizo delivery' => Icons.shopping_bag_rounded,
      'padel magic' => Icons.watch_rounded,
      'astrology consultation app' => Icons.self_improvement_rounded,
      _ => Icons.phone_android_rounded,
    };
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isNeon = accentColor == AppTheme.neon;
    return Material(
      color: isNeon ? AppTheme.neon : AppTheme.black,
      borderRadius: BorderRadius.circular(999),
      elevation: 2,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isNeon ? AppTheme.black : Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isNeon ? AppTheme.black : Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_outward_rounded,
                size: 14,
                color: isNeon ? AppTheme.black : Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


