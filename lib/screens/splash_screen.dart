import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  double _progress = 0.0;
  late Timer _progressTimer;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    _progress = 0.0;
    
    // Smooth loading progress bar (animates to 100% in 2.5 seconds)
    const int totalTicks = 50;
    const Duration tickDuration = Duration(milliseconds: 50);
    int currentTick = 0;

    _progressTimer = Timer.periodic(tickDuration, (timer) {
      currentTick++;
      setState(() {
        _progress = (currentTick / totalTicks).clamp(0.0, 1.0);
      });

      if (_progress >= 1.0) {
        timer.cancel();
        _onLoadingCompleted();
      }
    });
  }

  void _onLoadingCompleted() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_isTransitioning) {
        _launchPortfolio();
      }
    });
  }

  void _launchPortfolio() {
    if (_isTransitioning) return;
    _isTransitioning = true;
    _progressTimer.cancel();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.08, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 1100),
      ),
    );
  }

  @override
  void dispose() {
    _progressTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060608),
      body: SafeArea(
        child: Stack(
          children: [
            // Cyber scanlines background effect in purple
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: CustomPaint(
                  painter: _ScanlinePainter(),
                ),
              ),
            ),

            // Centered Logo & Loading Content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cool & Unique double-spinning neon loader (No white!)
                      const SizedBox(
                        height: 160,
                        width: 160,
                        child: Center(
                          child: CoolNeonLoader(),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Neon Brand Titles (No white!)
                      Text(
                        "BEARROW",
                        style: GoogleFonts.shareTechMono(
                          color: AppTheme.neon,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 10.0,
                          shadows: [
                            Shadow(
                              color: AppTheme.neon.withValues(alpha: 0.25),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms, duration: 800.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 6),
                      Text(
                        "PORTFOLIO BRAND SYSTEM",
                        style: GoogleFonts.shareTechMono(
                          color: AppTheme.purple,
                          fontSize: 12,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                              color: AppTheme.purple.withValues(alpha: 0.25),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 800.ms),
                      const SizedBox(height: 64),

                      // Progress Percentage Info in brand colors
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _progress >= 1.0 ? "LAUNCHING SYSTEM..." : "LOADING ENGINE...",
                            style: GoogleFonts.shareTechMono(
                              color: AppTheme.purple.withValues(alpha: 0.8),
                              fontSize: 12,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Text(
                            "${(_progress * 100).toInt()}%",
                            style: GoogleFonts.shareTechMono(
                              color: AppTheme.neon,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Progress Track
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.purple.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: AppTheme.purple.withValues(alpha: 0.15)),
                        ),
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              widthFactor: _progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppTheme.purple, AppTheme.neon],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.neon.withValues(alpha: 0.25),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Access Button (shows when progress completes)
                      AnimatedOpacity(
                        opacity: _progress >= 1.0 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: IgnorePointer(
                          ignoring: _progress < 1.0,
                          child: TextButton(
                            onPressed: _launchPortfolio,
                            style: TextButton.styleFrom(
                              backgroundColor: AppTheme.neon,
                              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                              shape: const BeveledRectangleBorder(
                                side: BorderSide(color: AppTheme.neon, width: 1.5),
                              ),
                            ),
                            child: Text(
                              "ENTER PORTFOLIO",
                              style: GoogleFonts.shareTechMono(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3.0,
                              ),
                            ),
                          )
                              .animate(onPlay: (controller) => controller.repeat())
                              .shimmer(delay: 500.ms, duration: 1500.ms, color: Colors.white.withValues(alpha: 0.5)),
                        ),
                      ),
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

// Cool & Unique Double-Spinning segmented rings loader
class CoolNeonLoader extends StatefulWidget {
  const CoolNeonLoader({super.key});

  @override
  State<CoolNeonLoader> createState() => _CoolNeonLoaderState();
}

class _CoolNeonLoaderState extends State<CoolNeonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
        final angle1 = _controller.value * 2 * math.pi;
        final angle2 = -_controller.value * 2 * math.pi;
        final pulse = 1.0 + 0.1 * math.sin(_controller.value * 2 * math.pi);

        return SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer neon ring (dashed/segmented) spinning clockwise
              Transform.rotate(
                angle: angle1,
                child: CustomPaint(
                  size: const Size(100, 100),
                  painter: _SegmentedRingPainter(
                    color: AppTheme.neon,
                    strokeWidth: 4,
                    segments: 3,
                  ),
                ),
              ),

              // Inner purple ring (dashed/segmented) spinning counter-clockwise
              Transform.rotate(
                angle: angle2,
                child: CustomPaint(
                  size: const Size(76, 76),
                  painter: _SegmentedRingPainter(
                    color: AppTheme.purple,
                    strokeWidth: 3.5,
                    segments: 2,
                  ),
                ),
              ),

              // Center pulsing neon core
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.neon,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.neon.withValues(alpha: 0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentedRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int segments;

  _SegmentedRingPainter({
    required this.color,
    required this.strokeWidth,
    required this.segments,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final sweepAngle = (2 * math.pi) / (segments * 2);

    for (int i = 0; i < segments; i++) {
      final startAngle = i * (sweepAngle * 2);
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedRingPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth || oldDelegate.segments != segments;
  }
}

// Custom Painter for retro scanning line background effect in purple
class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.purple.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    for (double y = 0; y < size.height; y += 4.0) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
