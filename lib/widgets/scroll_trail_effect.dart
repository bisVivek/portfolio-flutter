import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';
import 'spider_man_sprite.dart';
import 'web_physics.dart';

/// Section anchor for trail node connections.
class TrailSectionNode {
  const TrailSectionNode({required this.id, required this.key});

  final String id;
  final GlobalKey key;
}

/// Neon scroll trail overlay — zig-zag path grows with scroll, sparks on movement.
class ScrollTrailEffect extends StatefulWidget {
  const ScrollTrailEffect({
    super.key,
    required this.scrollController,
    required this.sectionNodes,
    this.onSwingComplete,
  });

  final ScrollController scrollController;
  final List<TrailSectionNode> sectionNodes;
  final void Function(Offset spideyPosition)? onSwingComplete;

  @override
  State<ScrollTrailEffect> createState() => _ScrollTrailEffectState();
}

class _TrailSpark {
  _TrailSpark({
    required this.position,
    required this.velocity,
    required this.born,
  });

  Offset position;
  Offset velocity;
  final double born;
}

class _ScrollTrailEffectState extends State<ScrollTrailEffect>
    with SingleTickerProviderStateMixin {
  late final WebPhysicsSimulator _physics;
  late final AnimationController _introController;
  late final Animation<double> _introCurve;

  double _scrollOffset = 0;
  double _scrollVelocity = 0;
  double _lastTickScroll = 0;
  Duration _lastTickTime = Duration.zero;
  double _time = 0;
  bool _physicsActive = true;
  bool _completing = false;

  final _sparks = <_TrailSpark>[];
  final _pathHistory = <Offset>[];
  static const _maxHistory = 48;
  static const _maxSparks = 64;

  @override
  void initState() {
    super.initState();
    _physics = WebPhysicsSimulator();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _introCurve = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOutCubic,
    );
    _introController.forward();

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
        _scrollVelocity =
            (_scrollOffset - _lastTickScroll) / math.max(dt, 0.001);
        _lastTickScroll = _scrollOffset;
        _physics.step(dt: dt, scrollVelocity: _scrollVelocity);
      }
    }

    _updateTrailEffects(dt);
    _checkSwingComplete();
    setState(() {});
    SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _checkSwingComplete() {
    if (_completing || widget.onSwingComplete == null) return;
    if (!_introController.isCompleted) return;

    final scrolledEnough = _scrollOffset >= 90;
    final timedFallback = _time >= 7 && _scrollOffset >= 30;
    if (!scrolledEnough && !timedFallback) return;

    _completing = true;
    _physicsActive = false;

    final size = MediaQuery.sizeOf(context);
    final anchor = Offset(size.width * 0.5, 24);
    final path = _buildZigZagPath(
      anchor,
      _currentThreadLength(size),
      size,
    );
    final spideyPos = path.length >= 2 ? path.last : anchor;

    widget.onSwingComplete?.call(spideyPos);
  }

  void _updateTrailEffects(double dt) {
    final speed = _scrollVelocity.abs();
    if (speed > 8) {
      final size = MediaQuery.sizeOf(context);
      final path = _buildZigZagPath(
        Offset(size.width * 0.5, 24),
        _currentThreadLength(size),
        size,
      );
      if (path.length >= 2) {
        final head = path.last;
        _pathHistory.add(head);
        while (_pathHistory.length > _maxHistory) {
          _pathHistory.removeAt(0);
        }

        final sparkCount = (speed / 18).ceil().clamp(1, 4);
        final scrollUp = _scrollVelocity < 0;
        for (var i = 0; i < sparkCount; i++) {
          if (_sparks.length >= _maxSparks) _sparks.removeAt(0);
          final t = math.Random().nextDouble();
          final along = path[math.min((t * (path.length - 1)).floor(), path.length - 2)];
          final next = path[math.min((t * (path.length - 1)).floor() + 1, path.length - 1)];
          final pos = Offset.lerp(along, next, t)!;
          _sparks.add(
            _TrailSpark(
              position: pos,
              velocity: Offset(
                (math.Random().nextDouble() - 0.5) * 40,
                scrollUp ? -speed * 0.35 : speed * 0.2,
              ),
              born: _time,
            ),
          );
        }
      }
    }

    _sparks.removeWhere((s) => _time - s.born > 1.4);
    for (final spark in _sparks) {
      spark.position += spark.velocity * dt;
      spark.velocity *= math.pow(0.92, dt * 60).toDouble();
    }
  }

  double _currentThreadLength(Size size) {
    final maxThread = size.height - 56;
    final rawLength = (_scrollOffset * 1.05 + 72) * _physics.stretchFactor;
    return math.min(rawLength, maxThread) * _introCurve.value;
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
    _introController.dispose();
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

      nodes.add(_ResolvedNode(id: node.id, center: global));
    }
    return nodes;
  }

  List<Offset> _buildZigZagPath(Offset anchor, double threadLength, Size size) {
    if (threadLength <= 0) return [anchor];

    final points = <Offset>[anchor];
    var x = anchor.dx + _physics.swingOffset;
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_introController, _physics]),
      builder: (context, _) {
        final size = MediaQuery.sizeOf(context);
        final anchor = Offset(size.width * 0.5, 24);
        final threadLength = _currentThreadLength(size);
        final path = _buildZigZagPath(anchor, threadLength, size);

        return RepaintBoundary(
          child: CustomPaint(
            painter: _ScrollTrailPainter(
              scrollVelocity: _scrollVelocity,
              swingOffset: _physics.swingOffset,
              time: _time,
              path: path,
              anchor: anchor,
              pathHistory: List.unmodifiable(_pathHistory),
              sparks: List.unmodifiable(_sparks),
              sectionNodes: _resolveNodes(size),
              trailsVisible: !_completing,
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

class _ScrollTrailPainter extends CustomPainter {
  _ScrollTrailPainter({
    required this.scrollVelocity,
    required this.swingOffset,
    required this.time,
    required this.path,
    required this.anchor,
    required this.pathHistory,
    required this.sparks,
    required this.sectionNodes,
    required this.trailsVisible,
  });

  final double scrollVelocity;
  final double swingOffset;
  final double time;
  final List<Offset> path;
  final Offset anchor;
  final List<Offset> pathHistory;
  final List<_TrailSpark> sparks;
  final List<_ResolvedNode> sectionNodes;
  final bool trailsVisible;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width < 280 || path.length < 2 || !trailsVisible) return;

    _drawAmbientDust(canvas, size);
    _drawPathHistory(canvas);
    _drawMainTrail(canvas);
    _connectSectionNodes(canvas);
    _drawSparks(canvas);
    _drawAnchorPulse(canvas, anchor);
    _drawSpiderMan(canvas, path);
  }

  void _drawAmbientDust(Canvas canvas, Size size) {
    final random = math.Random(7);
    for (var i = 0; i < 18; i++) {
      final seed = random.nextDouble();
      final x = size.width * seed;
      final baseY = (seed * size.height * 2 + time * 14 + i * 50) % (size.height + 20);
      final drift = math.sin(time * 0.7 + seed * 5) * 10;
      final alpha = 0.05 + math.sin(time + seed * 8) * 0.03;

      canvas.drawCircle(
        Offset(x + drift, baseY),
        1 + seed,
        Paint()..color = AppTheme.neon.withValues(alpha: alpha.clamp(0.02, 0.12)),
      );
    }
  }

  void _drawPathHistory(Canvas canvas) {
    if (pathHistory.length < 2) return;

    final scrollUp = scrollVelocity < 0;
    for (var i = 1; i < pathHistory.length; i++) {
      final age = i / pathHistory.length;
      final alpha = (0.35 * age * (scrollUp ? 1.3 : 1.0)).clamp(0.0, 0.35);

      canvas.drawLine(
        pathHistory[i - 1],
        pathHistory[i],
        Paint()
          ..color = (scrollUp ? AppTheme.purple : AppTheme.neon)
              .withValues(alpha: alpha)
          ..strokeWidth = 2 + age * 4
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 + age * 6),
      );
    }
  }

  void _drawMainTrail(Canvas canvas) {
    final pathObj = Path()..moveTo(path.first.dx, path.first.dy);
    for (var i = 1; i < path.length; i++) {
      pathObj.lineTo(path[i].dx, path[i].dy);
    }

    final velocityGlow = scrollVelocity.abs().clamp(0, 50) / 50;
    final scrollUp = scrollVelocity < 0;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 + velocityGlow * 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 + velocityGlow * 6)
      ..shader = ui.Gradient.linear(
        path.first,
        path.last,
        [
          AppTheme.neon.withValues(alpha: 0.08),
          (scrollUp ? AppTheme.purple : AppTheme.neon)
              .withValues(alpha: 0.2 + velocityGlow * 0.25),
        ],
      );

    canvas.drawPath(pathObj, glowPaint);

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 + velocityGlow * 1.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = ui.Gradient.linear(
        path.first,
        path.last,
        [
          AppTheme.white.withValues(alpha: 0.25),
          AppTheme.neon.withValues(alpha: 0.85),
          AppTheme.purple.withValues(alpha: 0.6 + velocityGlow * 0.3),
        ],
        [0.0, 0.55, 1.0],
      );

    canvas.drawPath(pathObj, corePaint);

    _drawFlowDots(canvas);
  }

  void _drawFlowDots(Canvas canvas) {
    if (path.length < 2) return;

    final scrollUp = scrollVelocity < 0;
    final speed = scrollVelocity.abs().clamp(0, 50);
    final dotCount = 6 + (speed / 8).floor();
    final flow = (time * (scrollUp ? -1.8 : 1.2)) % 1.0;

    for (var i = 0; i < dotCount; i++) {
      final t = ((i / dotCount) + flow) % 1.0;
      final pos = _pointAlongPath(t);
      if (pos == null) continue;

      final alpha = 0.2 + math.sin(time * 3 + i) * 0.15;
      canvas.drawCircle(
        pos,
        2 + (speed / 25),
        Paint()
          ..color = (scrollUp ? AppTheme.purple : AppTheme.neon)
              .withValues(alpha: alpha.clamp(0.1, 0.55))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }

  Offset? _pointAlongPath(double t) {
    if (path.length < 2) return null;

    final totalSegments = path.length - 1;
    final scaled = t * totalSegments;
    final index = scaled.floor().clamp(0, totalSegments - 1);
    final localT = scaled - index;
    return Offset.lerp(path[index], path[index + 1], localT);
  }

  void _drawSpiderMan(Canvas canvas, List<Offset> points) {
    if (points.length < 2) return;

    final center = points.last;
    final prev = points[points.length - 2];
    final delta = center - prev;
    final segmentAngle =
        delta.distance > 0 ? math.atan2(delta.dy, delta.dx) : math.pi / 2;

    final scrollUp = scrollVelocity < 0;
    final speed = scrollVelocity.abs().clamp(0, 50);
    final velocityTilt = (scrollVelocity * 0.002).clamp(-0.35, 0.35);
    final sway = math.sin(time * 3.2) * 0.06 + swingOffset * 0.0025;
    final scale = 1.0 + speed / 120;

    canvas.save();
    canvas.translate(center.dx - 28, center.dy - 28);
    SpiderManPainter(
      angle: segmentAngle + math.pi / 2 + sway + velocityTilt,
      sway: 0,
      scale: scale,
      glowColor: scrollUp ? AppTheme.purple : SpiderManPainter.spideyRed,
      showWebStrand: true,
      time: time,
    ).paint(canvas, const Size(56, 56));
    canvas.restore();
  }

  void _drawAnchorPulse(Canvas canvas, Offset anchor) {
    final pulse = 0.5 + math.sin(time * 2.5) * 0.5;
    canvas.drawCircle(
      anchor,
      8 + pulse * 4,
      Paint()
        ..color = AppTheme.neon.withValues(alpha: 0.12 + pulse * 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(
      anchor,
      3,
      Paint()..color = AppTheme.neon.withValues(alpha: 0.9),
    );
  }

  void _connectSectionNodes(Canvas canvas) {
    for (final node in sectionNodes) {
      final threadPoint = _nearestPointOnPolyline(path, node.center.dy);
      if (threadPoint == null) continue;

      final pulse = 0.5 + math.sin(time * 2 + node.center.dx * 0.01) * 0.5;
      final pathObj = Path()
        ..moveTo(threadPoint.dx, threadPoint.dy)
        ..quadraticBezierTo(
          (threadPoint.dx + node.center.dx) / 2,
          (threadPoint.dy + node.center.dy) / 2 - 24,
          node.center.dx,
          node.center.dy,
        );

      canvas.drawPath(
        pathObj,
        Paint()
          ..color = AppTheme.purple.withValues(alpha: 0.08 + pulse * 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawPath(
        pathObj,
        Paint()
          ..color = AppTheme.white.withValues(alpha: 0.2 + pulse * 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      canvas.drawCircle(
        node.center,
        5 + pulse * 2,
        Paint()
          ..color = AppTheme.neon.withValues(alpha: 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawCircle(
        node.center,
        3,
        Paint()..color = AppTheme.neon.withValues(alpha: 0.8),
      );
    }
  }

  void _drawSparks(Canvas canvas) {
    for (final spark in sparks) {
      final age = (time - spark.born).clamp(0.0, 1.4);
      final alpha = (1 - age / 1.4).clamp(0.0, 1.0);
      final scrollUp = scrollVelocity < 0;

      canvas.drawCircle(
        spark.position,
        2 + alpha * 2,
        Paint()
          ..color = (scrollUp ? AppTheme.purple : AppTheme.neon)
              .withValues(alpha: alpha * 0.7)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
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

  @override
  bool shouldRepaint(covariant _ScrollTrailPainter oldDelegate) {
    return (oldDelegate.scrollVelocity - scrollVelocity).abs() > 0.1 ||
        (oldDelegate.swingOffset - swingOffset).abs() > 0.1 ||
        (oldDelegate.time - time).abs() > 0.016 ||
        oldDelegate.path.length != path.length ||
        oldDelegate.pathHistory.length != pathHistory.length ||
        oldDelegate.sparks.length != sparks.length ||
        oldDelegate.sectionNodes.length != sectionNodes.length ||
        oldDelegate.trailsVisible != trailsVisible;
  }
}
