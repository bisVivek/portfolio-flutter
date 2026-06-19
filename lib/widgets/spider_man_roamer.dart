import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';
import 'spider_man_sprite.dart';

/// Landing spot on a widget — resolved via [key] + [alignment].
class SpiderRoamTarget {
  const SpiderRoamTarget({
    required this.id,
    required this.key,
    this.alignment = Alignment.topCenter,
    this.weight = 1,
    this.flipFromTop = false,
    this.wrapWeb = false,
  });

  final String id;
  final GlobalKey key;
  final Alignment alignment;
  final int weight;
  final bool flipFromTop;
  final bool wrapWeb;
}

class _ResolvedRoamTarget {
  const _ResolvedRoamTarget({
    required this.target,
    required this.position,
    required this.bounds,
  });

  final SpiderRoamTarget target;
  final Offset position;
  final Rect? bounds;
}

/// Spider-Man swings between UI targets after the intro trail phase ends.
class SpiderManRoamer extends StatefulWidget {
  const SpiderManRoamer({
    super.key,
    required this.targets,
    required this.startPosition,
    this.paused = false,
  });

  final List<SpiderRoamTarget> targets;
  final Offset startPosition;
  final bool paused;

  @override
  State<SpiderManRoamer> createState() => _SpiderManRoamerState();
}

class _SpiderManRoamerState extends State<SpiderManRoamer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _swingController;
  late Offset _position;
  Offset _from = Offset.zero;
  Offset _to = Offset.zero;
  Offset _webAnchor = Offset.zero;
  Offset? _flipPeak;
  double _time = 0;
  bool _physicsActive = true;
  Timer? _roamTimer;
  SpiderRoamTarget? _currentTarget;
  Rect? _wrapBounds;
  bool _isFlipJump = false;
  final _random = math.Random();
  Offset? _prevPos;
  double _facingAngle = math.pi / 2;

  @override
  void initState() {
    super.initState();
    _position = widget.startPosition;
    _from = widget.startPosition;
    _to = widget.startPosition;
    _webAnchor = Offset(widget.startPosition.dx, widget.startPosition.dy - 80);

    _swingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..addListener(() => setState(() {}));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scheduleNextRoam(initialDelay: const Duration(milliseconds: 800));
      _startTick();
    });
  }

  void _startTick() {
    _physicsActive = true;
    SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _tick(Duration _) {
    if (!mounted || !_physicsActive) return;
    _time += 0.016;
    setState(() {});
    SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _scheduleNextRoam({Duration? initialDelay}) {
    _roamTimer?.cancel();
    final delay = initialDelay ??
        Duration(milliseconds: 2400 + _random.nextInt(2200));
    _roamTimer = Timer(delay, _pickAndSwing);
  }

  Rect? _resolveBounds(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return null;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    final topLeft = box.localToGlobal(Offset.zero);
    return topLeft & box.size;
  }

  _ResolvedRoamTarget? _resolveTarget(SpiderRoamTarget target, Size screen) {
    final bounds = _resolveBounds(target.key);
    if (bounds == null) return null;

    final center = bounds.center;
    if (center.dy < -60 || center.dy > screen.height + 60) return null;
    if (center.dx < -60 || center.dx > screen.width + 60) return null;

    final aligned = target.alignment.alongSize(bounds.size);
    final position = bounds.topLeft + aligned;

    return _ResolvedRoamTarget(
      target: target,
      position: position,
      bounds: bounds,
    );
  }

  List<_ResolvedRoamTarget> _visibleTargets(Size screen) {
    final results = <_ResolvedRoamTarget>[];
    for (final target in widget.targets) {
      final resolved = _resolveTarget(target, screen);
      if (resolved != null) results.add(resolved);
    }
    return results;
  }

  void _pickAndSwing() {
    if (!mounted || widget.paused) {
      _scheduleNextRoam();
      return;
    }

    final screen = MediaQuery.sizeOf(context);
    final visible = _visibleTargets(screen);
    if (visible.isEmpty) {
      _scheduleNextRoam(initialDelay: const Duration(seconds: 2));
      return;
    }

    final pool = <_ResolvedRoamTarget>[];
    for (final entry in visible) {
      for (var i = 0; i < entry.target.weight; i++) {
        pool.add(entry);
      }
    }

    _ResolvedRoamTarget picked;
    do {
      picked = pool[_random.nextInt(pool.length)];
    } while (picked.target.id == _currentTarget?.id && pool.length > 1);

    _currentTarget = picked.target;
    _wrapBounds = picked.target.wrapWeb ? picked.bounds : null;
    _isFlipJump = picked.target.flipFromTop && picked.bounds != null;

    _from = _position;
    _to = picked.position;

    if (_isFlipJump && picked.bounds != null) {
      final b = picked.bounds!;
      _swingController.duration = const Duration(milliseconds: 1150);
      _webAnchor = Offset(
        b.center.dx + (_random.nextDouble() - 0.5) * 30,
        b.top - 35,
      );
      _flipPeak = Offset(
        b.center.dx + (_random.nextDouble() - 0.5) * b.width * 0.15,
        b.top - 95 - _random.nextDouble() * 35,
      );
      _to = Offset(b.center.dx, b.top + 14);

      if (_random.nextDouble() < 0.55) {
        _from = Offset(
          b.center.dx + (_random.nextDouble() - 0.5) * b.width * 0.35,
          b.top - 75 - _random.nextDouble() * 45,
        );
        _position = _from;
      }
    } else {
      _swingController.duration = const Duration(milliseconds: 950);
      _flipPeak = null;
      _webAnchor = Offset(
        (_from.dx + _to.dx) / 2 + (_random.nextDouble() - 0.5) * 70,
        math.min(_from.dy, _to.dy) - 75 - _random.nextDouble() * 45,
      );
    }

    _swingController.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      _position = _to;
      _scheduleNextRoam();
    });
  }

  Offset _currentPosition() {
    if (!_swingController.isAnimating) return _position;

    final t = Curves.easeInOutCubic.transform(_swingController.value);

    if (_isFlipJump && _flipPeak != null) {
      final u = 1 - t;
      final peak = _flipPeak!;
      return Offset(
        u * u * _from.dx + 2 * u * t * peak.dx + t * t * _to.dx,
        u * u * _from.dy + 2 * u * t * peak.dy + t * t * _to.dy,
      );
    }

    final mid = Offset(
      _webAnchor.dx,
      _webAnchor.dy + math.sin(t * math.pi) * 35,
    );

    if (t < 0.5) {
      final local = t * 2;
      return Offset(
        _lerp(_from.dx, mid.dx, local),
        _lerp(_from.dy, mid.dy, local),
      );
    }
    final local = (t - 0.5) * 2;
    return Offset(
      _lerp(mid.dx, _to.dx, local),
      _lerp(mid.dy, _to.dy, local),
    );
  }

  double _flipSpin() {
    if (!_swingController.isAnimating || !_isFlipJump) return 0;
    final t = _swingController.value;
    return math.sin(t * math.pi) * math.pi * 1.35;
  }

  double _currentAngle(Offset pos) {
    if (_prevPos != null) {
      final delta = pos - _prevPos!;
      if (delta.distance > 0.8) {
        _facingAngle = math.atan2(delta.dy, delta.dx) + math.pi / 2;
      }
    }
    _prevPos = pos;
    if (!_swingController.isAnimating && _wrapBounds != null) {
      return math.pi + math.sin(_time * 2.2) * 0.04;
    }
    return _facingAngle + math.sin(_time * 2.5) * 0.06;
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  void dispose() {
    _physicsActive = false;
    _roamTimer?.cancel();
    _swingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pos = _currentPosition();
    final swinging = _swingController.isAnimating;
    final wrapping = !swinging && _wrapBounds != null && _currentTarget?.wrapWeb == true;
    final onEye = _currentTarget?.id == 'eye' && !swinging;
    final figureSize = onEye ? 64.0 : (wrapping ? 60.0 : 56.0);

    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (wrapping && _wrapBounds != null)
            CustomPaint(
              painter: _WidgetWebWrapPainter(
                bounds: _wrapBounds!,
                hero: pos,
                time: _time,
              ),
              size: MediaQuery.sizeOf(context),
            ),
          if (swinging)
            CustomPaint(
              painter: _WebSwingPainter(
                anchor: _webAnchor,
                hero: pos,
                thick: _isFlipJump,
              ),
              size: MediaQuery.sizeOf(context),
            ),
          Positioned(
            left: pos.dx - figureSize / 2,
            top: pos.dy - figureSize / 2,
            child: SpiderManFigure(
              angle: _currentAngle(pos),
              sway: swinging ? 0 : math.sin(_time * 3.2) * 0.05,
              scale: onEye ? 1.15 : 1.0,
              glowColor: onEye ? AppTheme.purple : SpiderManPainter.spideyRed,
              showWebStrand: !swinging && !wrapping,
              flipSpin: _flipSpin(),
              armsOut: wrapping,
              time: _time,
              size: figureSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _WebSwingPainter extends CustomPainter {
  _WebSwingPainter({
    required this.anchor,
    required this.hero,
    this.thick = false,
  });

  final Offset anchor;
  final Offset hero;
  final bool thick;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(anchor.dx, anchor.dy)
      ..quadraticBezierTo(
        (anchor.dx + hero.dx) / 2,
        (anchor.dy + hero.dy) / 2 - (thick ? 50 : 30),
        hero.dx,
        hero.dy - 12,
      );

    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.neon.withValues(alpha: thick ? 0.28 : 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = thick ? 5 : 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.white.withValues(alpha: thick ? 0.5 : 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = thick ? 2 : 1.5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(
      anchor,
      thick ? 5 : 4,
      Paint()..color = AppTheme.neon.withValues(alpha: 0.75),
    );
  }

  @override
  bool shouldRepaint(covariant _WebSwingPainter oldDelegate) {
    return oldDelegate.anchor != anchor ||
        oldDelegate.hero != hero ||
        oldDelegate.thick != thick;
  }
}

class _WidgetWebWrapPainter extends CustomPainter {
  _WidgetWebWrapPainter({
    required this.bounds,
    required this.hero,
    required this.time,
  });

  final Rect bounds;
  final Offset hero;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final pulse = 0.5 + math.sin(time * 2.8) * 0.5;
    final inset = bounds.inflate(6);

    final glowPaint = Paint()
      ..color = AppTheme.neon.withValues(alpha: 0.08 + pulse * 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final webPaint = Paint()
      ..color = AppTheme.white.withValues(alpha: 0.32 + pulse * 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    final corners = [
      inset.topLeft,
      inset.topRight,
      inset.bottomRight,
      inset.bottomLeft,
    ];

    final rrect = RRect.fromRectAndRadius(inset, const Radius.circular(12));
    canvas.drawRRect(rrect, glowPaint);
    canvas.drawRRect(rrect, webPaint);

    for (var i = 0; i < corners.length; i++) {
      final c = corners[i];
      final next = corners[(i + 1) % corners.length];
      canvas.drawLine(c, next, webPaint);

      final center = inset.center;
      canvas.drawLine(
        c,
        center,
        Paint()
          ..color = AppTheme.white.withValues(alpha: 0.14)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1,
      );

      for (var j = 1; j <= 3; j++) {
        final t = j / 4;
        final radial = Offset(
          c.dx + (center.dx - c.dx) * t,
          c.dy + (center.dy - c.dy) * t,
        );
        final spread = Offset(
          radial.dx + (next.dx - c.dx) * 0.12,
          radial.dy + (next.dy - c.dy) * 0.12,
        );
        canvas.drawLine(
          radial,
          spread,
          Paint()
            ..color = AppTheme.neon.withValues(alpha: 0.18)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.1,
        );
      }
    }

    final leftHand = hero + const Offset(-18, 2);
    final rightHand = hero + const Offset(18, 2);
    for (final corner in corners) {
      _drawHandWeb(canvas, leftHand, corner, pulse);
      _drawHandWeb(canvas, rightHand, corner, pulse * 0.85);
    }

    canvas.drawLine(
      Offset(inset.left, inset.top - 18),
      Offset(inset.right, inset.top - 18),
      Paint()
        ..color = AppTheme.white.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );
  }

  void _drawHandWeb(Canvas canvas, Offset hand, Offset corner, double pulse) {
    final path = Path()
      ..moveTo(hand.dx, hand.dy)
      ..quadraticBezierTo(
        (hand.dx + corner.dx) / 2,
        (hand.dy + corner.dy) / 2 - 12,
        corner.dx,
        corner.dy,
      );

    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.neon.withValues(alpha: 0.12 + pulse * 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.white.withValues(alpha: 0.38 + pulse * 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _WidgetWebWrapPainter oldDelegate) {
    return oldDelegate.bounds != bounds ||
        oldDelegate.hero != hero ||
        (oldDelegate.time - time).abs() > 0.03;
  }
}
