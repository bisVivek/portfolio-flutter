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
            // Ambient Background Video (pvb.mp4) without control buttons
            const Positioned.fill(
              child: BackgroundVideo(
                assetPath: 'assets/videoes/pvb.mp4',
                overlayOpacity: 0.48,
                showControls: false,
              ),
            ),
            // Hero Content Overlay (No right photo box)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                isWide ? 64 : 24,
                isWide ? 72 : 48,
                isWide ? 64 : 24,
                isWide ? 96 : 56,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: _HeroContent(
                        onExploreWork: onExploreWork,
                        onContact: onContact,
                      ),
                    ),
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
      children: [
        Text(
          'BUILDING APPS\nWITH 🔥 PASSION',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: isWide ? 64 : 40,
                color: AppTheme.white,
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
            fontSize: isWide ? 18 : 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 100.ms),
        const SizedBox(height: 16),
        Text(
          'Hi, I\'m ${PortfolioData.name}. ${PortfolioData.summary.split('.').first}.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.white.withValues(alpha: 0.7),
                fontSize: isWide ? 17 : 15,
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
                side: BorderSide(color: AppTheme.white.withValues(alpha: 0.35)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.white.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, color: AppTheme.white, size: 20),
      ),
    );
  }
}
