import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../utils/url_helper.dart';
import '../widgets/background_video.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, this.onExploreWork, this.onContact});

  final VoidCallback? onExploreWork;
  final VoidCallback? onContact;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return ClipRect(
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            // Bright Ambient Background Video (pvb.mp4) without blackish darkening
            const Positioned.fill(
              child: BackgroundVideo(
                assetPath: 'assets/videoes/pvb.mp4',
                overlayOpacity: 0.15,
                showControls: false,
              ),
            ),
            // Hero Content & Tech Stack Showcase Overlay
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                isWide ? 48 : 24,
                isWide ? 56 : 40,
                isWide ? 48 : 24,
                isWide ? 72 : 48,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 6,
                              child: _HeroContent(
                                onExploreWork: onExploreWork,
                                onContact: onContact,
                              ),
                            ),
                            const SizedBox(width: 40),
                            const Expanded(
                              flex: 5,
                              child: _TechStackShowcase(),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroContent(
                              onExploreWork: onExploreWork,
                              onContact: onContact,
                            ),
                            const SizedBox(height: 36),
                            const _TechStackShowcase(),
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
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({this.onExploreWork, this.onContact});

  final VoidCallback? onExploreWork;
  final VoidCallback? onContact;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'BUILDING ',
                style: TextStyle(
                  color: AppTheme.black,
                  shadows: [
                    Shadow(
                      color: Colors.white.withValues(alpha: 0.9),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: 'APPS\n',
                style: TextStyle(
                  color: AppTheme.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.95),
                      blurRadius: 16,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: 'WITH 🔥 PASSION',
                style: TextStyle(
                  color: AppTheme.black,
                  shadows: [
                    Shadow(
                      color: Colors.white.withValues(alpha: 0.9),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: isWide ? 56 : 38,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
        )
            .animate()
            .fadeIn(duration: 900.ms)
            .slideY(begin: 0.1, end: 0, duration: 1000.ms),
        const SizedBox(height: 20),
        Text(
          PortfolioData.title,
          style: TextStyle(
            color: AppTheme.neon,
            fontSize: isWide ? 26 : 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 3.0,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.95),
                blurRadius: 14,
                offset: const Offset(0, 2),
              ),
              const Shadow(
                color: Colors.black,
                blurRadius: 24,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 100.ms),
        const SizedBox(height: 16),
        Text(
          'Hi, I\'m ${PortfolioData.name}. ${PortfolioData.summary.split('.').first}.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.black,
                fontSize: isWide ? 19 : 17,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.85),
                    blurRadius: 10,
                  ),
                ],
              ),
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
        const SizedBox(height: 36),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(
              onPressed: onContact ?? onExploreWork,
              child: const Text('CONTACT ME'),
            ),
            OutlinedButton.icon(
              onPressed: onExploreWork,
              icon: const Icon(Icons.work_outline, size: 18),
              label: const Text('MY WORK'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.white,
                side: BorderSide(color: AppTheme.white.withValues(alpha: 0.6)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                backgroundColor: AppTheme.black.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 800.ms, delay: 300.ms),
        const SizedBox(height: 28),
        Row(
          children: [
            _SocialBtn(
              icon: Icons.code,
              onTap: () => launchExternalUrl(PortfolioData.contact.githubUrl),
            ),
            const SizedBox(width: 10),
            _SocialBtn(
              icon: Icons.work_outline,
              onTap: () => launchExternalUrl(PortfolioData.contact.linkedinUrl),
            ),
            const SizedBox(width: 10),
            _SocialBtn(
              icon: Icons.email_outlined,
              onTap: () => launchEmail(PortfolioData.contact.email),
            ),
          ],
        ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
      ],
    );
  }
}

class _TechStackShowcase extends StatefulWidget {
  const _TechStackShowcase();

  @override
  State<_TechStackShowcase> createState() => _TechStackShowcaseState();
}

class _TechStackShowcaseState extends State<_TechStackShowcase>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final val = _controller.value * math.pi * 2;
        final float1 = math.sin(val) * 7;
        final float2 = math.cos(val) * 9;
        final float3 = math.sin(val + 1.2) * 8;
        final float4 = math.cos(val + 2.0) * 7;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Transform.translate(
              offset: Offset(0, float1),
              child: const _CyberTechChip(
                icon: Icons.flutter_dash,
                title: 'FLUTTER & DART',
                subtitle: 'Android · iOS · Web · Wear OS',
                accentColor: Color(0xFF40C4FF),
                badgeText: 'CORE FRAMEWORK',
              ),
            ),
            const SizedBox(height: 14),
            Transform.translate(
              offset: Offset(0, float2),
              child: const _CyberTechChip(
                icon: Icons.local_fire_department_rounded,
                title: 'FIREBASE & REST APIs',
                subtitle: 'Firestore · Auth · FCM · REST',
                accentColor: Color(0xFFFFCA28),
                badgeText: 'CLOUD & BACKEND',
              ),
            ),
            const SizedBox(height: 14),
            Transform.translate(
              offset: Offset(0, float3),
              child: const _CyberTechChip(
                icon: Icons.phonelink_setup_rounded,
                title: 'AGORA & TWILIO SDK',
                subtitle: 'Audio/Video Consultations & Payments',
                accentColor: AppTheme.neon,
                badgeText: 'INTEGRATIONS',
              ),
            ),
            const SizedBox(height: 14),
            Transform.translate(
              offset: Offset(0, float4),
              child: const _CyberTechChip(
                icon: Icons.verified_outlined,
                title: '150+ PLAY STORE APPS',
                subtitle: '50+ Apple App Store Production Releases',
                accentColor: AppTheme.purple,
                badgeText: 'SHIPPED APPS',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CyberTechChip extends StatefulWidget {
  const _CyberTechChip({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.badgeText,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final String badgeText;

  @override
  State<_CyberTechChip> createState() => _CyberTechChipState();
}

class _CyberTechChipState extends State<_CyberTechChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(_hovered ? -8 : 0, 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: _hovered
              ? AppTheme.black.withValues(alpha: 0.85)
              : AppTheme.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _hovered
                ? widget.accentColor
                : widget.accentColor.withValues(alpha: 0.4),
            width: _hovered ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor
                  .withValues(alpha: _hovered ? 0.35 : 0.15),
              blurRadius: _hovered ? 24 : 12,
              spreadRadius: _hovered ? 1 : -2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.6),
                ),
              ),
              child: Icon(
                widget.icon,
                color: widget.accentColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: widget.accentColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        widget.badgeText,
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: AppTheme.white.withValues(alpha: 0.78),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  const _SocialBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.white.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: AppTheme.white, size: 20),
      ),
    );
  }
}
