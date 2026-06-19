import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shared canvas-drawn Spider-Man used by trail + roamer.
class SpiderManPainter extends CustomPainter {
  SpiderManPainter({
    required this.angle,
    this.sway = 0,
    this.scale = 1,
    this.glowColor,
    this.showWebStrand = true,
    this.time = 0,
    this.flipSpin = 0,
    this.armsOut = false,
  });

  final double angle;
  final double sway;
  final double scale;
  final Color? glowColor;
  final bool showWebStrand;
  final double time;
  final double flipSpin;
  final bool armsOut;

  static const spideyRed = Color(0xFFE23636);
  static const spideyBlue = Color(0xFF1565C0);
  static const spideyDark = Color(0xFF1A1A2E);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle + sway + flipSpin);
    canvas.scale(scale);

    if (showWebStrand) {
      final strandPaint = Paint()
        ..color = AppTheme.white.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(const Offset(0, -10), const Offset(0, -26), strandPaint);
    }

    final glow = glowColor ?? spideyRed;
    canvas.drawOval(
      const Rect.fromLTWH(-14, -8, 28, 34),
      Paint()
        ..color = glow.withValues(alpha: 0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    final bodyFill = Paint()..style = PaintingStyle.fill;
    final bodyStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppTheme.black.withValues(alpha: 0.85);

    final legPaint = Paint()
      ..color = spideyBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final legWiggle = math.sin(time * 4) * 2;
    canvas.drawLine(const Offset(-7, 10), Offset(-12 + legWiggle, 22), legPaint);
    canvas.drawLine(Offset(-12 + legWiggle, 22), const Offset(-8, 30), legPaint);
    canvas.drawLine(const Offset(7, 10), Offset(12 - legWiggle, 22), legPaint);
    canvas.drawLine(Offset(12 - legWiggle, 22), const Offset(8, 30), legPaint);

    bodyFill.color = spideyRed;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(0, 6), width: 14, height: 16),
        const Radius.circular(6),
      ),
      bodyFill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(0, 6), width: 14, height: 16),
        const Radius.circular(6),
      ),
      bodyStroke,
    );

    final webPaint = Paint()
      ..color = AppTheme.black.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    canvas.drawLine(const Offset(0, 0), const Offset(0, 12), webPaint);
    canvas.drawLine(const Offset(-5, 4), const Offset(5, 4), webPaint);
    canvas.drawLine(const Offset(-4, 8), const Offset(4, 8), webPaint);

    final armPaint = Paint()
      ..color = spideyRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;

    if (armsOut) {
      final reach = 20 + math.sin(time * 3) * 2;
      canvas.drawLine(const Offset(-6, 0), Offset(-reach, -2), armPaint);
      canvas.drawLine(const Offset(6, 0), Offset(reach, -2), armPaint);
      canvas.drawLine(Offset(-reach, -2), Offset(-reach - 4, 4), armPaint);
      canvas.drawLine(Offset(reach, -2), Offset(reach + 4, 4), armPaint);
    } else {
      canvas.drawLine(const Offset(-6, 2), const Offset(-16, -4), armPaint);
      canvas.drawLine(const Offset(-16, -4), const Offset(-14, -10), armPaint);
      canvas.drawLine(const Offset(6, 2), const Offset(14, 6), armPaint);
      canvas.drawLine(const Offset(14, 6), const Offset(18, 12), armPaint);
    }

    bodyFill.color = spideyRed;
    canvas.drawCircle(const Offset(0, -6), 7, bodyFill);
    canvas.drawCircle(const Offset(0, -6), 7, bodyStroke);

    bodyFill.color = AppTheme.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-5.5, -8.5, 4.5, 6),
        const Radius.circular(2),
      ),
      bodyFill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(1, -8.5, 4.5, 6),
        const Radius.circular(2),
      ),
      bodyFill,
    );

    final eyeOutline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = AppTheme.black.withValues(alpha: 0.85);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-5.5, -8.5, 4.5, 6),
        const Radius.circular(2),
      ),
      eyeOutline,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(1, -8.5, 4.5, 6),
        const Radius.circular(2),
      ),
      eyeOutline,
    );

    bodyFill.color = spideyDark.withValues(alpha: 0.5);
    canvas.drawCircle(const Offset(0, 5), 2.2, bodyFill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SpiderManPainter oldDelegate) {
    return (oldDelegate.angle - angle).abs() > 0.01 ||
        (oldDelegate.sway - sway).abs() > 0.01 ||
        (oldDelegate.scale - scale).abs() > 0.01 ||
        oldDelegate.showWebStrand != showWebStrand ||
        (oldDelegate.flipSpin - flipSpin).abs() > 0.01 ||
        oldDelegate.armsOut != armsOut ||
        (oldDelegate.time - time).abs() > 0.05;
  }
}

/// Fixed-size Spider-Man figure widget.
class SpiderManFigure extends StatelessWidget {
  const SpiderManFigure({
    super.key,
    required this.angle,
    this.sway = 0,
    this.scale = 1,
    this.glowColor,
    this.showWebStrand = true,
    this.time = 0,
    this.flipSpin = 0,
    this.armsOut = false,
    this.size = 56,
  });

  final double angle;
  final double sway;
  final double scale;
  final Color? glowColor;
  final bool showWebStrand;
  final double time;
  final double flipSpin;
  final bool armsOut;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: SpiderManPainter(
          angle: angle,
          sway: sway,
          scale: scale,
          glowColor: glowColor,
          showWebStrand: showWebStrand,
          time: time,
          flipSpin: flipSpin,
          armsOut: armsOut,
        ),
      ),
    );
  }
}
