import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import '../utils/url_helper.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, this.index = 0});

  final Project project;
  final int index;

  static const List<Color> _accents = [
    Color(0xFF7B61FF), // Purple (Erizo)
    Color(0xFFC1FF00), // Neon Lime (Zofanso)
    Color(0xFF00E5FF), // Electric Cyan (Erizo Delivery)
    Color(0xFFFF6D00), // Amber Orange (Padel Magic)
    Color(0xFFE91E63), // Magenta Pink (Astrology)
  ];

  Color get _accent => _accents[index % _accents.length];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.12),
            blurRadius: 40,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Ambient Radial Backdrop Lighting
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: isWide ? const Alignment(0.4, -0.2) : Alignment.topCenter,
                  radius: 0.95,
                  colors: [
                    _accent.withValues(alpha: 0.22),
                    const Color(0xFF07070F),
                  ],
                ),
              ),
            ),
          ),

          // Main Scene Layout
          Padding(
            padding: EdgeInsets.all(isWide ? 44 : 12),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Column: Editorial Information
                      Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: _buildEditorialDetails(context),
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Right Column: Hero Device Universe Scene
                      Expanded(
                        flex: 6,
                        child: _buildHeroDeviceScene(context),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroDeviceScene(context, height: 230),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: _buildEditorialDetails(context),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorialDetails(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final pageNum = '0${index + 1} / 05';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Counter Header
        Row(
          children: [
            Text(
              pageNum,
              style: TextStyle(
                fontSize: isWide ? 13 : 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: _accent == AppTheme.neon ? AppTheme.black : _accent,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 1,
              width: 32,
              color: _accent.withValues(alpha: 0.5),
            ),
          ],
        ),
        SizedBox(height: isWide ? 16 : 6),

        // Project Name Typography Reveal
        Text(
          project.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: isWide ? 34 : 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: Colors.white,
              ),
        ),

        // Subtitle Category Line
        if (project.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            project.subtitle!,
            style: TextStyle(
              fontSize: isWide ? 13 : 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: _accent == AppTheme.neon ? AppTheme.neon : _accent,
            ),
          ),
        ],

        SizedBox(height: isWide ? 16 : 8),

        // One-Line Editorial Description
        Text(
          '"${project.description}"',
          maxLines: isWide ? null : 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: isWide ? 15 : 12,
                height: 1.4,
                color: Colors.white.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
        ),
        SizedBox(height: isWide ? 22 : 10),

        // Technology Stack Pills
        Text(
          'TECHNOLOGY',
          style: TextStyle(
            fontSize: isWide ? 10 : 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: isWide ? 8 : 6,
          runSpacing: isWide ? 8 : 6,
          children: (isWide ? project.techStack : project.techStack.take(4)).map((tech) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 12 : 8,
                vertical: isWide ? 6 : 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                '#$tech',
                style: TextStyle(
                  fontSize: isWide ? 12 : 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: isWide ? 22 : 10),

        // Key Features / Highlights
        if (project.highlights.isNotEmpty) ...[
          Text(
            'KEY FEATURES',
            style: TextStyle(
              fontSize: isWide ? 10 : 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (isWide ? project.highlights : project.highlights.take(2)).map((h) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✓ ',
                      style: TextStyle(
                        fontSize: isWide ? 14 : 12,
                        fontWeight: FontWeight.w900,
                        color: _accent == AppTheme.neon ? AppTheme.neon : _accent,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        h,
                        maxLines: isWide ? null : 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isWide ? 13 : 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],

        // Action Buttons: [ VIEW PROJECT ↗ ]
        SizedBox(height: isWide ? 28 : 12),
        Wrap(
          spacing: isWide ? 14 : 8,
          runSpacing: isWide ? 10 : 6,
          children: [
            if (project.websiteUrl != null)
              _UniverseActionButton(
                label: 'VIEW WEBSITE ↗',
                accentColor: _accent,
                onTap: () => launchExternalUrl(project.websiteUrl!),
              ),
            if (project.playStoreUrl != null)
              _UniverseActionButton(
                label: 'PLAY STORE ↗',
                accentColor: _accent,
                onTap: () => launchExternalUrl(project.playStoreUrl!),
              ),
            if (project.appStoreUrl != null)
              _UniverseActionButton(
                label: 'APP STORE ↗',
                accentColor: _accent,
                onTap: () => launchExternalUrl(project.appStoreUrl!),
              ),
          ],
        ),
      ],
    );
  }

  /// Hero Device Universe Scene
  Widget _buildHeroDeviceScene(BuildContext context, {double? height}) {
    final isPadel = project.name.contains('PADEL');
    final isAstrology = project.name.contains('ASTROLOGY');
    final isDelivery = project.name.contains('DELIVERY');
    final isZofanso = project.name.contains('ZOFANSO');

    return Container(
      height: height ?? double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF04040A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Ambient Light Sphere
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.75,
                  colors: [
                    _accent.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Project-Specific Hero Visual Environment
          if (isPadel)
            _buildPadelSmartwatchScene(context)
          else if (isAstrology)
            _buildAstrologyDualPhoneScene(context)
          else if (isDelivery)
            _buildDeliveryMapScene(context)
          else if (isZofanso)
            _buildZofansoGroceryScene(context)
          else
            _buildErizoCommerceScene(context),

          // Floating Glass Badge: ⚡ SHIPPED TO PRODUCTION
          Positioned(
            bottom: 18,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⚡ ', style: TextStyle(fontSize: 13)),
                  Text(
                    isPadel ? 'SHIPPED TO PLAY STORE' : 'SHIPPED TO PRODUCTION',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PROJECT 01: Erizo Multivendor Commerce Scene (3-Image 3D Stack)
  Widget _buildErizoCommerceScene(BuildContext context) {
    final cover = project.coverImage ?? 'assets/images/erizo_portfolio_banner.png';
    final extras = project.additionalImages ?? [
      'assets/images/erizo_promo.png',
      'assets/images/erizo_web_home.png',
    ];

    return _buildThreeImageShowcase(
      context,
      mainCover: cover,
      extraImages: extras,
      accentColor: _accent,
      tagLabel: 'erizo.in Store',
      tagIcon: Icons.shopping_basket_rounded,
    );
  }

  /// PROJECT 02: Zofanso Food & Grocery Scene (3-Image 3D Stack)
  Widget _buildZofansoGroceryScene(BuildContext context) {
    final cover = project.coverImage ?? 'assets/images/zofanso_portfolio_banner.png';
    final extras = project.additionalImages ?? [
      'assets/images/zofanso_play_store.png',
      'assets/images/erizo_promo.png',
    ];

    return _buildThreeImageShowcase(
      context,
      mainCover: cover,
      extraImages: extras,
      accentColor: AppTheme.neon,
      tagLabel: '4.8★ Rating · 5K+ Downloads',
      tagIcon: Icons.star_rounded,
    );
  }

  /// Helper: Reusable 3-Image 3D Perspective Smartphone Stack Showcase
  Widget _buildThreeImageShowcase(
    BuildContext context, {
    required String? mainCover,
    required List<String> extraImages,
    required Color accentColor,
    required String tagLabel,
    required IconData tagIcon,
  }) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    final imgLeft = extraImages.isNotEmpty ? extraImages[0] : mainCover;
    final imgRight = extraImages.length > 1 ? extraImages[1] : (extraImages.isNotEmpty ? extraImages[0] : mainCover);
    final imgCenter = mainCover ?? (extraImages.isNotEmpty ? extraImages[0] : null);

    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. LEFT PHONE MOCKUP (Background Left Layer, rotated -12deg)
        if (imgLeft != null)
          Positioned(
            left: isMobile ? 12 : 18,
            top: isMobile ? 28 : 40,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateZ(-0.16)
                // ignore: deprecated_member_use
                ..scale(0.85),
              alignment: Alignment.center,
              child: Container(
                width: isMobile ? 125 : 140,
                height: isMobile ? 205 : 230,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: 25,
                      offset: const Offset(-8, 12),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  imgLeft,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildFallbackVisual(),
                ),
              ),
            ),
          ),

        // 2. RIGHT PHONE MOCKUP (Background Right Layer, rotated +12deg)
        if (imgRight != null)
          Positioned(
            right: isMobile ? 12 : 18,
            top: isMobile ? 28 : 40,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateZ(0.16)
                // ignore: deprecated_member_use
                ..scale(0.85),
              alignment: Alignment.center,
              child: Container(
                width: isMobile ? 125 : 140,
                height: isMobile ? 205 : 230,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: 25,
                      offset: const Offset(8, 12),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  imgRight,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildFallbackVisual(),
                ),
              ),
            ),
          ),

        // 3. CENTER HERO PHONE MOCKUP (Foreground Main Device Object)
        if (imgCenter != null)
          Container(
            width: isMobile ? 150 : 165,
            height: isMobile ? 230 : 265,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: accentColor, width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.45),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    imgCenter,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallbackVisual(),
                  ),
                ),
                // Dynamic Island / Top Speaker Notch
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // 4. Floating Badge Tag
        Positioned(
          top: isMobile ? 12 : 18,
          right: isMobile ? 12 : 18,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tagIcon, size: 13, color: accentColor),
                const SizedBox(width: 6),
                Text(
                  tagLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// PROJECT 03: Erizo Delivery Map & Route Scene
  Widget _buildDeliveryMapScene(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    final cover = project.coverImage;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Visually extending Map Route Line behind phone
        CustomPaint(
          size: Size(isMobile ? 220 : 260, isMobile ? 220 : 260),
          painter: _MapRouteLinePainter(color: AppTheme.cyan),
        ),

        // Floating Location Pin Marker extending outside phone
        Positioned(
          top: isMobile ? 20 : 36,
          left: isMobile ? 24 : 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppTheme.cyan),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.cyan),
                const SizedBox(width: 4),
                const Text(
                  'GPS Live Route',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Main Smartphone Frame
        Container(
          width: isMobile ? 150 : 175,
          height: isMobile ? 230 : 270,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.cyan, width: 3),
          ),
          clipBehavior: Clip.antiAlias,
          child: cover != null
              ? Image.asset(
                  cover,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildFallbackVisual(),
                )
              : _buildFallbackVisual(),
        ),
      ],
    );
  }

  /// PROJECT 04: Padel Magic Wear OS Smartwatch Scene
  Widget _buildPadelSmartwatchScene(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    final cover = project.coverImage;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Floating Sport Pulse Rings around Watch
        Container(
          width: isMobile ? 230 : 260,
          height: isMobile ? 230 : 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF6D00).withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
        ),
        Container(
          width: isMobile ? 205 : 235,
          height: isMobile ? 205 : 235,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF6D00).withValues(alpha: 0.4),
              width: 1,
            ),
          ),
        ),

        // Watch Strap Background
        Container(
          width: isMobile ? 65 : 70,
          height: isMobile ? 240 : 300,
          decoration: BoxDecoration(
            color: const Color(0xFF141420),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
        ),

        // Realistic Wear OS Circular Smartwatch Frame
        Container(
          width: isMobile ? 185 : 200,
          height: isMobile ? 185 : 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            border: Border.all(color: const Color(0xFFFF6D00), width: 4),
          ),
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0C0C16),
            ),
            clipBehavior: Clip.antiAlias,
            child: cover != null
                ? Image.asset(
                    cover,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => _buildPadelWatchFallback(),
                  )
                : _buildPadelWatchFallback(),
          ),
        ),
      ],
    );
  }

  Widget _buildPadelWatchFallback() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(12),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.watch_rounded, color: Color(0xFFFF6D00), size: 38),
          SizedBox(height: 6),
          Text(
            'PADEL MAGIC',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          Text(
            'Wear OS Tracker',
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// PROJECT 05: Astrology Dual Phone RTC Consultation Scene
  Widget _buildAstrologyDualPhoneScene(BuildContext context) {
    final cover = project.coverImage ?? 'assets/images/img-3.jpeg';
    final extra = (project.additionalImages?.isNotEmpty ?? false)
        ? project.additionalImages![0]
        : 'assets/images/img-4.jpeg';

    return Stack(
      alignment: Alignment.center,
      children: [
        // Glowing Audio/Video Communication Waveform Line between devices
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            9,
            (i) => AnimatedContainer(
              duration: Duration(milliseconds: 300 + (i * 100)),
              width: 4,
              height: (i % 4 + 1) * 18.0,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFE91E63),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Phone 1 (Left - Consultant Phone Screen with Real Screenshot)
        Positioned(
          left: 24,
          child: Transform.rotate(
            angle: -0.12,
            child: Container(
              width: 135,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE91E63), width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withValues(alpha: 0.35),
                    blurRadius: 24,
                  ),
                  const BoxShadow(color: Colors.black87, blurRadius: 20),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      cover,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildRtcScreen(
                        'CONSULTANT VIDEO',
                        Icons.video_call_rounded,
                        const Color(0xFFE91E63),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.video_call_rounded, size: 11, color: Color(0xFFE91E63)),
                          SizedBox(width: 4),
                          Text('Agora RTC', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Phone 2 (Right - User Phone Screen with Real Screenshot)
        Positioned(
          right: 24,
          child: Transform.rotate(
            angle: 0.12,
            child: Container(
              width: 135,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.neon, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.neon.withValues(alpha: 0.35),
                    blurRadius: 24,
                  ),
                  const BoxShadow(color: Colors.black87, blurRadius: 20),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      extra,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildRtcScreen(
                        'CLIENT RTC AUDIO',
                        Icons.mic_rounded,
                        AppTheme.neon,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.mic_rounded, size: 11, color: AppTheme.neon),
                          SizedBox(width: 4),
                          Text('Twilio Live', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRtcScreen(String label, IconData icon, Color color) {
    return Container(
      color: const Color(0xFF0E0E1B),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 34),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Agora · Twilio',
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackVisual() {
    return Container(
      color: const Color(0xFF0F0F1D),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.phone_android_rounded, color: _accent, size: 40),
          const SizedBox(height: 12),
          Text(
            project.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _UniverseActionButton extends StatelessWidget {
  const _UniverseActionButton({
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final isNeon = accentColor == AppTheme.neon;
    return Material(
      color: isNeon ? AppTheme.neon : Colors.white,
      borderRadius: BorderRadius.circular(999),
      elevation: 4,
      shadowColor: Colors.black38,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 20 : 12,
            vertical: isWide ? 12 : 8,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.black,
              fontWeight: FontWeight.w900,
              fontSize: isWide ? 12 : 10,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

class _MapRouteLinePainter extends CustomPainter {
  const _MapRouteLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(20, 220)
      ..cubicTo(60, 160, 100, 240, 150, 140)
      ..cubicTo(190, 60, 220, 120, 250, 40);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}




