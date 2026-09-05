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
            padding: EdgeInsets.all(isWide ? 44 : 22),
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
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroDeviceScene(context, height: 280),
                        const SizedBox(height: 28),
                        _buildEditorialDetails(context),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorialDetails(BuildContext context) {
    final pageNum = '0${index + 1} / 05';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Counter Header
        Row(
          children: [
            Text(
              pageNum,
              style: TextStyle(
                fontSize: 13,
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
        const SizedBox(height: 16),

        // Project Name Typography Reveal
        Text(
          project.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                color: Colors.white,
              ),
        ),

        // Subtitle Category Line
        if (project.subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            project.subtitle!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: _accent == AppTheme.neon ? AppTheme.neon : _accent,
            ),
          ),
        ],

        const SizedBox(height: 16),

        // One-Line Editorial Description
        Text(
          '"${project.description}"',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 15,
                height: 1.55,
                color: Colors.white.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
        ),
        const SizedBox(height: 22),

        // Technology Stack Pills
        Text(
          'TECHNOLOGY',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.techStack.map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                '#$tech',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 22),

        // Key Features / Highlights
        if (project.highlights.isNotEmpty) ...[
          Text(
            'KEY FEATURES',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: project.highlights.map((h) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✓ ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: _accent == AppTheme.neon ? AppTheme.neon : _accent,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        h,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
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
        const SizedBox(height: 28),
        Wrap(
          spacing: 14,
          runSpacing: 10,
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
            _buildPadelSmartwatchScene()
          else if (isAstrology)
            _buildAstrologyDualPhoneScene()
          else if (isDelivery)
            _buildDeliveryMapScene()
          else if (isZofanso)
            _buildZofansoGroceryScene()
          else
            _buildErizoCommerceScene(),

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

  /// PROJECT 01: Erizo Multivendor Commerce Scene
  Widget _buildErizoCommerceScene() {
    final cover = project.coverImage;
    final extras = project.additionalImages ?? [];

    return Stack(
      alignment: Alignment.center,
      children: [
        // Floating UI Screenshot Fragment 1 (Left background)
        if (extras.isNotEmpty)
          Positioned(
            left: 12,
            top: 24,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 130,
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black87, blurRadius: 20),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  extras[0],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.black),
                ),
              ),
            ),
          ),

        // Floating UI Screenshot Fragment 2 (Right background)
        if (extras.length > 1)
          Positioned(
            right: 12,
            bottom: 24,
            child: Transform.rotate(
              angle: 0.2,
              child: Container(
                width: 130,
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black87, blurRadius: 20),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  extras[1],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.black),
                ),
              ),
            ),
          ),

        // Center Hero Smartphone Object
        Transform.rotate(
          angle: -0.04,
          child: Container(
            width: 175,
            height: 270,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: _accent, width: 3),
              boxShadow: [
                BoxShadow(
                  color: _accent.withValues(alpha: 0.4),
                  blurRadius: 35,
                  spreadRadius: 2,
                ),
                const BoxShadow(
                  color: Colors.black87,
                  blurRadius: 40,
                  offset: Offset(0, 16),
                ),
              ],
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
        ),

        // Floating product UI tag element
        Positioned(
          top: 30,
          right: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.purple.withValues(alpha: 0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_basket_rounded,
                    size: 14, color: AppTheme.purple),
                SizedBox(width: 6),
                Text(
                  'erizo.in Store',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// PROJECT 02: Zofanso Food & Grocery Scene
  Widget _buildZofansoGroceryScene() {
    final cover = project.coverImage;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Floating Grocery / Food UI cards around phone
        Positioned(
          left: 16,
          bottom: 40,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.neon.withValues(alpha: 0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, size: 16, color: AppTheme.neon),
                SizedBox(width: 6),
                Text(
                  '4.8★ Rating (5K+ Downloads)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Center Hero Phone
        Transform.rotate(
          angle: 0.04,
          child: Container(
            width: 175,
            height: 270,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppTheme.neon, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neon.withValues(alpha: 0.35),
                  blurRadius: 35,
                ),
                const BoxShadow(
                  color: Colors.black87,
                  blurRadius: 40,
                  offset: Offset(0, 16),
                ),
              ],
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
        ),
      ],
    );
  }

  /// PROJECT 03: Erizo Delivery Map & Route Scene
  Widget _buildDeliveryMapScene() {
    final cover = project.coverImage;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Visually extending Map Route Line behind phone
        CustomPaint(
          size: const Size(260, 260),
          painter: _MapRouteLinePainter(color: AppTheme.cyan),
        ),

        // Floating Location Pin Marker extending outside phone
        Positioned(
          top: 36,
          left: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppTheme.cyan),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.cyan.withValues(alpha: 0.5),
                  blurRadius: 12,
                ),
              ],
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
          width: 175,
          height: 270,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.cyan, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppTheme.cyan.withValues(alpha: 0.35),
                blurRadius: 35,
              ),
              const BoxShadow(
                color: Colors.black87,
                blurRadius: 40,
                offset: Offset(0, 16),
              ),
            ],
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
  Widget _buildPadelSmartwatchScene() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Floating Sport Pulse Rings around Watch
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF6D00).withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
        ),
        Container(
          width: 235,
          height: 235,
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
          width: 70,
          height: 300,
          decoration: BoxDecoration(
            color: const Color(0xFF141420),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
        ),

        // Realistic Wear OS Circular Smartwatch Frame
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            border: Border.all(color: const Color(0xFFFF6D00), width: 4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6D00).withValues(alpha: 0.5),
                blurRadius: 40,
              ),
              const BoxShadow(
                color: Colors.black87,
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0C0C16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (project.coverImage != null)
                  Image.asset(
                    project.coverImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(12),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.watch_rounded,
                          color: Color(0xFFFF6D00), size: 38),
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
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// PROJECT 05: Astrology Dual Phone RTC Consultation Scene
  Widget _buildAstrologyDualPhoneScene() {
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

        // Phone 1 (Left - Consultant Phone)
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
              child: _buildRtcScreen(
                'CONSULTANT VIDEO',
                Icons.video_call_rounded,
                const Color(0xFFE91E63),
              ),
            ),
          ),
        ),

        // Phone 2 (Right - User Phone)
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
              child: _buildRtcScreen(
                'CLIENT RTC AUDIO',
                Icons.mic_rounded,
                AppTheme.neon,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.black,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1,
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




