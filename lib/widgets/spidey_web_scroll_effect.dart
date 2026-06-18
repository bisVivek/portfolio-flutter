import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';
import 'web_physics.dart';

/// Section anchor for web node connections.
class WebSectionNode {
  const WebSectionNode({required this.id, required this.key});

  final String id;
  final GlobalKey key;
}

/// Spider-Man web overlay: viewport-anchored thread, physics swing, section nodes.
class SpideyWebScrollEffect extends StatefulWidget {
  const SpideyWebScrollEffect({
    super.key,
    required this.scrollController,
    required this.sectionNodes,
  });

  final ScrollController scrollController;
  final List<WebSectionNode> sectionNodes;

  @override
  State<SpideyWebScrollEffect> createState() => _SpideyWebScrollEffectState();
}

class _SpideyWebScrollEffectState extends State<SpideyWebScrollEffect>
    with SingleTickerProviderStateMixin {
  late final WebPhysicsSimulator _physics;
  late final AnimationController _dropController;
  late final Animation<double> _dropCurve;

  double _scrollOffset = 0;
  double _scrollVelocity = 0;
  double _lastTickScroll = 0;
  Duration _lastTickTime = Duration.zero;
  double _time = 0;
  bool _physicsActive = true;

  @override
  void initState() {
    super.initState();
    _physics = WebPhysicsSimulator();
    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _dropCurve = CurvedAnimation(
      parent: _dropController,
      curve: Curves.easeOutCubic,
    );
    _dropController.forward();

    widget.scrollController.addListener(_onScroll);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onScroll();
      _startPhysicsLoop();
    });
  }

  void _startPhysicsLoop() {
    _lastTickTime = SchedulerBinding.instance.currentFrameTimeStamp;
    SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _tick(Duration timeStamp) {
    if (!mounted || !_physicsActive) return;

    final dt = (timeStamp - _lastTickTime).inMicroseconds / 1e6;
    _lastTickTime = timeStamp;
    _time += dt;

    if (widget.scrollController.hasClients) {
      final position = widget.scrollController.position;
      if (position.hasContentDimensions) {
        _scrollVelocity = (_scrollOffset - _lastTickScroll) / math.max(dt, 0.001);
        _lastTickScroll = _scrollOffset;
        _physics.step(dt: dt, scrollVelocity: _scrollVelocity);
      }
    }

    setState(() {});
    SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final position = widget.scrollController.position;
    if (!position.hasContentDimensions) return;
    setState(() => _scrollOffset = widget.scrollController.offset);
  }

  @override
  void dispose() {
    _physicsActive = false;
    widget.scrollController.removeListener(_onScroll);
    _dropController.dispose();
    super.dispose();
  }

  List<_ResolvedNode> _resolveNodes(Size size) {
    final nodes = <_ResolvedNode>[];
    for (final node in widget.sectionNodes) {
      final context = node.key.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;

      final global = box.localToGlobal(box.size.center(Offset.zero));
      if (global.dy < -80 || global.dy > size.height + 80) continue;

      nodes.add(
        _ResolvedNode(
          id: node.id,
          center: Offset(global.dx, global.dy),
        ),
      );
    }
    return nodes;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_dropController, _physics]),
      builder: (context, _) {
        return RepaintBoundary(
          child: CustomPaint(
            painter: _SpideyWebPainter(
              scrollOffset: _scrollOffset,
              scrollVelocity: _scrollVelocity,
              swingOffset: _physics.swingOffset,
              stretchFactor: _physics.stretchFactor,
              dropProgress: _dropCurve.value,
              time: _time,
              sectionNodes: _resolveNodes(MediaQuery.sizeOf(context)),
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _ResolvedNode {
  const _ResolvedNode({required this.id, required this.center});

  final String id;
  final Offset center;
}

class _SpideyWebPainter extends CustomPainter {
  _SpideyWebPainter({
    required this.scrollOffset,
    required this.scrollVelocity,
    required this.swingOffset,
    required this.stretchFactor,
    required this.dropProgress,
    required this.time,
    required this.sectionNodes,
  });

  final double scrollOffset;
  final double scrollVelocity;
  final double swingOffset;
  final double stretchFactor;
  final double dropProgress;
  final double time;
  final List<_ResolvedNode> sectionNodes;

  static const _particleCount = 24;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width < 280) return;

    _drawParticles(canvas, size);

    final anchor = Offset(size.width * 0.5, 24);
    final maxThread = size.height - 56;
    final rawLength = (scrollOffset * 1.05 + 72) * stretchFactor;
    final threadLength = math.min(rawLength, maxThread) * dropProgress;
    final zigZagPoints = _buildZigZagPath(anchor, threadLength, size);
    final end = zigZagPoints.last;

    _drawWebAnchor(canvas, anchor);
    _drawZigZagThread(canvas, zigZagPoints);
    _drawSideThreads(canvas, anchor, zigZagPoints);
    _connectSectionNodes(canvas, zigZagPoints);
    _drawSpider(canvas, end, zigZagPoints);
  }

  /// Down-right → up-right zig-zag, trending down as user scrolls.
  List<Offset> _buildZigZagPath(Offset anchor, double threadLength, Size size) {
    if (threadLength <= 0) return [anchor];

    final points = <Offset>[anchor];
    var x = anchor.dx + swingOffset;
    var y = anchor.dy;
    var consumed = 0.0;
    var step = 0;

    const downRightDy = 82.0;
    const downRightDx = 52.0;
    const upRightDy = 30.0;
    const upRightDx = 68.0;

    while (consumed < threadLength - 8) {
      final isDownRight = step.isEven;
      final segDy = isDownRight ? downRightDy : upRightDy;
      final segDx = isDownRight ? downRightDx : upRightDx;
      final segLen = math.sqrt(segDx * segDx + segDy * segDy);

      final available = threadLength - consumed;
      final t = math.min(1.0, available / segLen);

      x += segDx * t;
      y += segDy * t;
      consumed += segLen * t;

      x = x.clamp(size.width * 0.12, size.width * 0.88);

      if (t >= 0.98) {
        points.add(Offset(x, y));
        step++;
      } else {
        points.add(Offset(x, y));
        break;
      }
    }

    if (points.length == 1) {
      points.add(Offset(x, anchor.dy + threadLength.clamp(8, threadLength)));
    }

    return points;
  }

  void _drawZigZagThread(Canvas canvas, List<Offset> points) {
    if (points.length < 2) return;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final velocityGlow = scrollVelocity.abs().clamp(0, 40) / 40;
    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.neon.withValues(alpha: 0.15 + velocityGlow * 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 + velocityGlow * 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.neon.withValues(alpha: 0.78)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final knotPaint = Paint()
      ..color = AppTheme.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (var i = 1; i < points.length - 1; i++) {
      final point = points[i];
      canvas.drawCircle(
        point,
        3.5,
        Paint()
          ..color = AppTheme.neon.withValues(alpha: 0.35)
          ..style = PaintingStyle.fill,
      );

      if (i > 0 && i < points.length - 1) {
        final prev = points[i - 1];
        final next = points[i + 1];
        final tangent = next - prev;
        final nLen = tangent.distance;
        if (nLen > 0) {
          final normal = Offset(-tangent.dy / nLen, tangent.dx / nLen);
          canvas.drawLine(point - normal * 10, point + normal * 10, knotPaint);
        }
      }
    }
  }

  void _drawParticles(Canvas canvas, Size size) {
    final random = math.Random(42);
    for (var i = 0; i < _particleCount; i++) {
      final seed = random.nextDouble();
      final x = size.width * seed;
      final baseY = (seed * size.height * 2 + time * 18 + i * 40) % (size.height + 20);
      final drift = math.sin(time * 0.8 + seed * 6) * 12;
      final alpha = 0.08 + math.sin(time + seed * 10) * 0.04;

      canvas.drawCircle(
        Offset(x + drift, baseY - 10),
        1.2 + seed * 1.5,
        Paint()..color = AppTheme.neon.withValues(alpha: alpha.clamp(0.04, 0.18)),
      );
    }
  }

  void _drawWebAnchor(Canvas canvas, Offset anchor) {
    final glow = Paint()
      ..color = AppTheme.neon.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(anchor, 14, glow);

    final hub = Paint()
      ..color = AppTheme.neon.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(anchor, 5, hub);

    final ring = Paint()
      ..color = AppTheme.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i < 10; i++) {
      final angle = (math.pi * 2 / 10) * i - math.pi / 2;
      final radialEnd = Offset(
        anchor.dx + math.cos(angle) * 42,
        anchor.dy + math.sin(angle) * 42,
      );
      canvas.drawLine(anchor, radialEnd, ring);
    }
    canvas.drawCircle(anchor, 42, ring);
    canvas.drawCircle(anchor, 26, ring..color = AppTheme.white.withValues(alpha: 0.1));
  }

  void _drawSideThreads(
    Canvas canvas,
    Offset anchor,
    List<Offset> mainPoints,
  ) {
    if (mainPoints.length < 2) return;

    for (final side in [-1.0, 1.0]) {
      final path = Path();
      for (var i = 0; i < mainPoints.length; i++) {
        final p = mainPoints[i];
        final offset = Offset(p.dx + side * 16, p.dy + (i == 0 ? 6 : 0));
        if (i == 0) {
          path.moveTo(anchor.dx + side * 20, anchor.dy + 8);
          path.lineTo(offset.dx, offset.dy);
        } else {
          path.lineTo(offset.dx, offset.dy);
        }
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = AppTheme.white.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  void _connectSectionNodes(Canvas canvas, List<Offset> mainPoints) {
    if (mainPoints.length < 2) return;

    for (final node in sectionNodes) {
      final threadPoint = _nearestPointOnPolyline(mainPoints, node.center.dy);
      if (threadPoint == null) continue;

      final path = Path()
        ..moveTo(threadPoint.dx, threadPoint.dy)
        ..quadraticBezierTo(
          (threadPoint.dx + node.center.dx) / 2,
          (threadPoint.dy + node.center.dy) / 2 - 20,
          node.center.dx,
          node.center.dy,
        );

      canvas.drawPath(
        path,
        Paint()
          ..color = AppTheme.neon.withValues(alpha: 0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = AppTheme.white.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      canvas.drawCircle(
        node.center,
        6,
        Paint()
          ..color = AppTheme.neon.withValues(alpha: 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawCircle(
        node.center,
        4,
        Paint()
          ..color = AppTheme.neon.withValues(alpha: 0.85)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        node.center,
        4,
        Paint()
          ..color = AppTheme.white.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  Offset? _nearestPointOnPolyline(List<Offset> points, double targetY) {
    if (points.length < 2) return null;
    if (targetY < points.first.dy || targetY > points.last.dy) return null;

    Offset? best;
    var bestDist = double.infinity;

    for (var i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      final minY = math.min(a.dy, b.dy);
      final maxY = math.max(a.dy, b.dy);
      if (targetY < minY - 20 || targetY > maxY + 20) continue;

      for (var t = 0.0; t <= 1.0; t += 0.1) {
        final p = Offset(
          a.dx + (b.dx - a.dx) * t,
          a.dy + (b.dy - a.dy) * t,
        );
        final dist = (p.dy - targetY).abs();
        if (dist < bestDist) {
          bestDist = dist;
          best = p;
        }
      }
    }
    return best;
  }

  void _drawSpider(Canvas canvas, Offset center, List<Offset> points) {
    canvas.save();
    canvas.translate(center.dx, center.dy);

    var angle = swingOffset * 0.012 + scrollVelocity * 0.001;
    if (points.length >= 2) {
      final prev = points[points.length - 2];
      final delta = center - prev;
      if (delta.distance > 0) {
        angle = math.atan2(delta.dy, delta.dx) + math.pi / 2;
      }
    }
    canvas.rotate(angle);

    canvas.drawCircle(
      Offset.zero,
      16,
      Paint()
        ..color = AppTheme.neon.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    final body = Paint()
      ..color = AppTheme.black
      ..style = PaintingStyle.fill;
    final outline = Paint()
      ..color = AppTheme.neon.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    canvas.drawCircle(const Offset(0, 2), 9, body);
    canvas.drawCircle(const Offset(0, 2), 9, outline);
    canvas.drawCircle(const Offset(0, -5), 6, body);
    canvas.drawCircle(const Offset(0, -5), 6, outline);

    final leg = Paint()
      ..color = AppTheme.neon.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    for (var i = -1; i <= 1; i++) {
      final spread = i * 4.0;
      canvas.drawLine(Offset(-5, 0), Offset(-18 - spread, 10 + i * 4), leg);
      canvas.drawLine(Offset(5, 0), Offset(18 + spread, 10 + i * 4), leg);
      canvas.drawLine(Offset(-4, 4), Offset(-16 - spread, 18 + i * 3), leg);
      canvas.drawLine(Offset(4, 4), Offset(16 + spread, 18 + i * 3), leg);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SpideyWebPainter oldDelegate) {
    return (oldDelegate.scrollOffset - scrollOffset).abs() > 0.1 ||
        (oldDelegate.swingOffset - swingOffset).abs() > 0.1 ||
        (oldDelegate.scrollVelocity - scrollVelocity).abs() > 0.1 ||
        (oldDelegate.dropProgress - dropProgress).abs() > 0.001 ||
        (oldDelegate.time - time).abs() > 0.016 ||
        oldDelegate.sectionNodes.length != sectionNodes.length;
  }
}
