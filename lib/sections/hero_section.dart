import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../utils/url_helper.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    this.onExploreWork,
    this.onContact,
    this.photoKey,
  });

  final VoidCallback? onExploreWork;
  final VoidCallback? onContact;
  final GlobalKey? photoKey;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Container(
      width: double.infinity,
      color: AppTheme.black,
      padding: EdgeInsets.fromLTRB(
        isWide ? 48 : 24,
        isWide ? 48 : 32,
        isWide ? 48 : 24,
        isWide ? 80 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _HeroContent(onExploreWork: onExploreWork, onContact: onContact)),
                    const SizedBox(width: 48),
                    Expanded(child: _HeroPhoto(isWide: true, photoKey: photoKey)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroContent(onExploreWork: onExploreWork, onContact: onContact),
                    const SizedBox(height: 40),
                    _HeroPhoto(isWide: false, photoKey: photoKey),
                  ],
                ),
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

class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({required this.isWide, this.photoKey});

  final bool isWide;
  final GlobalKey? photoKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: photoKey,
      height: isWide ? 480 : 360,
      decoration: BoxDecoration(
        color: AppTheme.purple,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Image.asset(
              PortfolioData.profilePhoto,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.person, size: 80, color: Colors.white54),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.neon,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${PortfolioData.name} · ${PortfolioData.title}',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 1000.ms, delay: 200.ms)
        .slideX(begin: 0.08, end: 0, delay: 200.ms);
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
