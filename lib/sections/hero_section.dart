import 'dart:math' as math;
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
            // Dark Ambient Background Video (pvb.mp4)
            Positioned.fill(
              child: BackgroundVideo(
                assetPath: 'assets/videoes/pvb.mp4',
                overlayOpacity: isWide ? 0.30 : 0.58,
                showControls: false,
              ),
            ),
            // Hero Content & Tech Stack Showcase Overlay
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                isWide ? 48 : 20,
                isWide ? 56 : 28,
                isWide ? 48 : 20,
                isWide ? 72 : 28,
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
                      : _HeroContent(
                          onExploreWork: onExploreWork,
                          onContact: onContact,
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
                  color: isWide ? AppTheme.black : AppTheme.white,
                  shadows: [
                    Shadow(
                      color: isWide
                          ? Colors.white.withValues(alpha: 0.9)
                          : Colors.black.withValues(alpha: 0.95),
                      blurRadius: isWide ? 12 : 16,
                      offset: isWide ? Offset.zero : const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: isWide ? 'APPS\n' : 'APPS ',
                style: TextStyle(
                  color: isWide ? AppTheme.white : AppTheme.neon,
                  shadows: [
                    Shadow(
                      color: isWide
                          ? Colors.black.withValues(alpha: 0.95)
                          : AppTheme.neon.withValues(alpha: 0.8),
                      blurRadius: 16,
                      offset: const Offset(0, 2),
                    ),
                    if (!isWide)
                      const Shadow(
                        color: Colors.black,
                        blurRadius: 16,
                      ),
                  ],
                ),
              ),
              TextSpan(
                text: isWide ? 'WITH 🔥 PASSION' : '\nWITH 🔥 PASSION',
                style: TextStyle(
                  color: isWide ? AppTheme.black : AppTheme.white,
                  shadows: [
                    Shadow(
                      color: isWide
                          ? Colors.white.withValues(alpha: 0.9)
                          : Colors.black.withValues(alpha: 0.95),
                      blurRadius: isWide ? 12 : 16,
                      offset: isWide ? Offset.zero : const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: isWide ? 56 : 28,
                fontWeight: FontWeight.w900,
                height: isWide ? 1.1 : 1.18,
                letterSpacing: isWide ? 0 : 0.5,
              ),
        )
            .animate()
            .fadeIn(duration: 900.ms)
            .slideY(begin: 0.1, end: 0, duration: 1000.ms),
        SizedBox(height: isWide ? 20 : 12),
        Text(
          PortfolioData.title,
          style: TextStyle(
            color: AppTheme.neon,
            fontSize: isWide ? 26 : 15,
            fontWeight: FontWeight.w900,
            letterSpacing: isWide ? 3.0 : 1.2,
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
        SizedBox(height: isWide ? 16 : 10),
        Text(
          'Hi, I\'m ${PortfolioData.name}. ${PortfolioData.summary.split('.').first}.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.black,
                fontSize: isWide ? 19 : 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
                height: isWide ? 1.3 : 1.4,
              ),
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
        SizedBox(height: isWide ? 36 : 20),
        Wrap(
          spacing: isWide ? 12 : 10,
          runSpacing: 10,
          children: [
            FilledButton(
              onPressed: onContact ?? onExploreWork,
              style: isWide
                  ? null
                  : FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
              child: const Text('CONTACT ME'),
            ),
            OutlinedButton.icon(
              onPressed: onExploreWork,
              icon: Icon(Icons.work_outline, size: isWide ? 18 : 16),
              label: const Text('MY WORK'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.white,
                side: BorderSide(color: AppTheme.white.withValues(alpha: 0.6)),
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 24 : 18,
                  vertical: isWide ? 18 : 14,
                ),
                backgroundColor: AppTheme.black.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                textStyle: TextStyle(
                  fontSize: isWide ? 14 : 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 800.ms, delay: 300.ms),
        SizedBox(height: isWide ? 28 : 18),
        Row(
          children: [
            _SocialBtn(
              icon: Icons.code,
              onTap: () => launchExternalUrl(PortfolioData.contact.githubUrl),
              isCompact: !isWide,
            ),
            const SizedBox(width: 10),
            _SocialBtn(
              icon: Icons.work_outline,
              onTap: () => launchExternalUrl(PortfolioData.contact.linkedinUrl),
              isCompact: !isWide,
            ),
            const SizedBox(width: 10),
            _SocialBtn(
              icon: Icons.email_outlined,
              onTap: () => launchEmail(PortfolioData.contact.email),
              isCompact: !isWide,
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
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    final chipsData = const [
      (
        leading: FlutterLogo(size: 24),
        compactLeading: FlutterLogo(size: 18),
        title: 'FLUTTER & DART',
        subtitle: 'Android · iOS · Web · Wear OS',
        color: Color(0xFF40C4FF),
        badge: 'CORE FRAMEWORK',
      ),
      (
        leading: _FirebaseFlameLogo(size: 24),
        compactLeading: _FirebaseFlameLogo(size: 18),
        title: 'FIREBASE & REST APIs',
        subtitle: 'Firestore · Auth · FCM · REST',
        color: Color(0xFFFFCA28),
        badge: 'CLOUD & BACKEND',
      ),
      (
        leading: Icon(Icons.android, color: Color(0xFF3DDC84), size: 24),
        compactLeading: Icon(Icons.android, color: Color(0xFF3DDC84), size: 18),
        title: 'ANDROID & iOS & WEAR OS',
        subtitle: 'Cross-Platform Native',
        color: Color(0xFF3DDC84),
        badge: 'MOBILE & WEARABLE',
      ),
      (
        leading: Icon(Icons.shop_two_rounded, color: AppTheme.neon, size: 24),
        compactLeading: Icon(Icons.shop_two_rounded, color: AppTheme.neon, size: 18),
        title: '150+ PLAY STORE APPS',
        subtitle: '50+ App Store Releases',
        color: AppTheme.neon,
        badge: 'SHIPPED APPS',
      ),
    ];

    if (!isWide) {
      return SizedBox(
        height: 84,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: chipsData.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final item = chipsData[index];
            return _CyberTechChip(
              leadingWidget: item.compactLeading,
              title: item.title,
              subtitle: item.subtitle,
              accentColor: item.color,
              badgeText: item.badge,
              isCompact: true,
            );
          },
        ),
      );
    }

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
              child: _CyberTechChip(
                leadingWidget: chipsData[0].leading,
                title: chipsData[0].title,
                subtitle: chipsData[0].subtitle,
                accentColor: chipsData[0].color,
                badgeText: chipsData[0].badge,
              ),
            ),
            const SizedBox(height: 14),
            Transform.translate(
              offset: Offset(0, float2),
              child: _CyberTechChip(
                leadingWidget: chipsData[1].leading,
                title: chipsData[1].title,
                subtitle: chipsData[1].subtitle,
                accentColor: chipsData[1].color,
                badgeText: chipsData[1].badge,
              ),
            ),
            const SizedBox(height: 14),
            Transform.translate(
              offset: Offset(0, float3),
              child: _CyberTechChip(
                leadingWidget: chipsData[2].leading,
                title: chipsData[2].title,
                subtitle: chipsData[2].subtitle,
                accentColor: chipsData[2].color,
                badgeText: chipsData[2].badge,
              ),
            ),
            const SizedBox(height: 14),
            Transform.translate(
              offset: Offset(0, float4),
              child: _CyberTechChip(
                leadingWidget: chipsData[3].leading,
                title: chipsData[3].title,
                subtitle: chipsData[3].subtitle,
                accentColor: chipsData[3].color,
                badgeText: chipsData[3].badge,
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
    this.leadingWidget,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.badgeText,
    this.isCompact = false,
  });

  final Widget? leadingWidget;
  final String title;
  final String subtitle;
  final Color accentColor;
  final String badgeText;
  final bool isCompact;

  @override
  State<_CyberTechChip> createState() => _CyberTechChipState();
}

class _CyberTechChipState extends State<_CyberTechChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return Container(
        width: 240,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.black.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.5),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withValues(alpha: 0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.6),
                ),
              ),
              child: widget.leadingWidget ??
                  Icon(
                    Icons.code,
                    color: widget.accentColor,
                    size: 18,
                  ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.white.withValues(alpha: 0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

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
              ? AppTheme.black.withValues(alpha: 0.88)
              : AppTheme.black.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _hovered
                ? widget.accentColor
                : widget.accentColor.withValues(alpha: 0.45),
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
              child: widget.leadingWidget ??
                  Icon(
                    Icons.code,
                    color: widget.accentColor,
                    size: 22,
                  ),
            ),
            const SizedBox(width: 14),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
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
            ),
          ],
        ),
      ),
    );
  }
}

/// Official 3D-styled Firebase Flame Logo Painter
class _FirebaseFlameLogo extends StatelessWidget {
  const _FirebaseFlameLogo({this.size = 24});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FirebaseFlamePainter(),
      ),
    );
  }
}

class _FirebaseFlamePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Facet 1: Amber Left Flame Facet
    final path1 = Path()
      ..moveTo(w * 0.12, h * 0.78)
      ..lineTo(w * 0.48, h * 0.08)
      ..lineTo(w * 0.68, h * 0.48)
      ..close();
    canvas.drawPath(
      path1,
      Paint()..color = const Color(0xFFFFA000),
    );

    // Facet 2: Bright Yellow Right Flame Facet
    final path2 = Path()
      ..moveTo(w * 0.88, h * 0.78)
      ..lineTo(w * 0.48, h * 0.08)
      ..lineTo(w * 0.68, h * 0.48)
      ..close();
    canvas.drawPath(
      path2,
      Paint()..color = const Color(0xFFFFCA28),
    );

    // Facet 3: Orange Front Flame Facet
    final path3 = Path()
      ..moveTo(w * 0.12, h * 0.78)
      ..lineTo(w * 0.5, h * 0.94)
      ..lineTo(w * 0.88, h * 0.78)
      ..lineTo(w * 0.58, h * 0.32)
      ..close();
    canvas.drawPath(
      path3,
      Paint()..color = const Color(0xFFF57C00),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SocialBtn extends StatelessWidget {
  const _SocialBtn({
    required this.icon,
    required this.onTap,
    this.isCompact = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final size = isCompact ? 38.0 : 44.0;
    final iconSize = isCompact ? 18.0 : 20.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppTheme.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.white.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: AppTheme.white, size: iconSize),
      ),
    );
  }
}

