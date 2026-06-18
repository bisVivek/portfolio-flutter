import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Subtle parallax orbs that drift with scroll for depth.
class ParallaxBackground extends StatelessWidget {
  const ParallaxBackground({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: scrollController,
      builder: (context, _) {
        if (!scrollController.hasClients) {
          return const SizedBox.expand();
        }
        final position = scrollController.position;
        if (!position.hasContentDimensions) {
          return const SizedBox.expand();
        }

        final offset = scrollController.offset;
        return RepaintBoundary(
          child: CustomPaint(
            painter: _ParallaxPainter(scrollOffset: offset),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _ParallaxPainter extends CustomPainter {
  _ParallaxPainter({required this.scrollOffset});

  final double scrollOffset;

  static const _layers = [
    (0.08, 0.06, 180.0, AppTheme.purple),
    (0.14, 0.10, 120.0, AppTheme.neon),
    (0.22, 0.04, 90.0, AppTheme.white),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < _layers.length; i++) {
      final (parallax, alpha, radius, color) = _layers[i];
      final cx = size.width * (0.15 + i * 0.28);
      final cy = size.height * 0.25 +
          math.sin(i * 1.7) * 40 -
          scrollOffset * parallax;

      final wrappedY = ((cy % (size.height + radius * 2)) + size.height + radius * 2) %
              (size.height + radius * 2) -
          radius;

      canvas.drawCircle(
        Offset(cx, wrappedY),
        radius,
        Paint()
          ..color = color.withValues(alpha: alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 48),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParallaxPainter oldDelegate) {
    return (oldDelegate.scrollOffset - scrollOffset).abs() > 0.5;
  }
}
