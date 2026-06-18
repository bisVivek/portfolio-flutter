import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

const kEyeSize = 132.0;

enum _EyeSpeechPhase { none, dontClick }

enum _BubbleTail { top, bottom, left, right }

enum _CoolBubbleStyle { neon, purple, white, warning }

class _IdleBubbleConfig {
  const _IdleBubbleConfig({
    required this.text,
    required this.tail,
    required this.style,
    required this.left,
    required this.bottom,
    required this.floatOffset,
  });

  final String text;
  final _BubbleTail tail;
  final _CoolBubbleStyle style;
  final double left;
  final double bottom;
  final double floatOffset;
}

const _stopMemeMessages = [
  'I SAID STOP! 🛑',
  'BRO STOP 😭',
  'STAHP 🙏',
  'Personal space!!!',
  'My eye is NOT a toy',
  'Why are you like this 💀',
  'Bonk. Go away 🔨',
  'Touch grass, not me',
];

const _idleMessages = [
  _IdleBubbleConfig(
    text: 'Are you still here?',
    tail: _BubbleTail.bottom,
    style: _CoolBubbleStyle.purple,
    left: 20,
    bottom: kEyeSize + 8,
    floatOffset: 0,
  ),
  _IdleBubbleConfig(
    text: 'Is it interesting? ✨',
    tail: _BubbleTail.left,
    style: _CoolBubbleStyle.neon,
    left: kEyeSize + 8,
    bottom: 52,
    floatOffset: 0.3,
  ),
  _IdleBubbleConfig(
    text: "Let's talk & connect!",
    tail: _BubbleTail.right,
    style: _CoolBubbleStyle.white,
    left: -130,
    bottom: 48,
    floatOffset: 0.6,
  ),
  _IdleBubbleConfig(
    text: 'POV: you found a dev 👀',
    tail: _BubbleTail.bottom,
    style: _CoolBubbleStyle.neon,
    left: 10,
    bottom: kEyeSize + 10,
    floatOffset: 0.2,
  ),
  _IdleBubbleConfig(
    text: 'No cap, hire me fr 💀',
    tail: _BubbleTail.left,
    style: _CoolBubbleStyle.purple,
    left: kEyeSize + 6,
    bottom: 36,
    floatOffset: 0.5,
  ),
  _IdleBubbleConfig(
    text: 'Sheesh, still scrolling?',
    tail: _BubbleTail.right,
    style: _CoolBubbleStyle.neon,
    left: -108,
    bottom: 64,
    floatOffset: 0.8,
  ),
  _IdleBubbleConfig(
    text: 'Plot twist: hire me 😂',
    tail: _BubbleTail.bottom,
    style: _CoolBubbleStyle.white,
    left: 24,
    bottom: kEyeSize + 4,
    floatOffset: 0.4,
  ),
  _IdleBubbleConfig(
    text: 'This is fine 🔥🐶',
    tail: _BubbleTail.left,
    style: _CoolBubbleStyle.purple,
    left: kEyeSize + 10,
    bottom: 58,
    floatOffset: 0.1,
  ),
  _IdleBubbleConfig(
    text: '404: patience not found',
    tail: _BubbleTail.right,
    style: _CoolBubbleStyle.neon,
    left: -125,
    bottom: 40,
    floatOffset: 0.55,
  ),
  _IdleBubbleConfig(
    text: 'Main character energy ✨',
    tail: _BubbleTail.bottom,
    style: _CoolBubbleStyle.white,
    left: 16,
    bottom: kEyeSize + 6,
    floatOffset: 0.35,
  ),
  _IdleBubbleConfig(
    text: 'Skill issue? Hire me instead',
    tail: _BubbleTail.left,
    style: _CoolBubbleStyle.warning,
    left: kEyeSize + 4,
    bottom: 42,
    floatOffset: 0.7,
  ),
  _IdleBubbleConfig(
    text: 'Got a project idea? 💡',
    tail: _BubbleTail.right,
    style: _CoolBubbleStyle.purple,
    left: -115,
    bottom: 56,
    floatOffset: 0.25,
  ),
];

/// Bottom-left cartoon eye — tracks cursor, speaks, opens/closes on tap.
class TrackingEyeWidget extends StatefulWidget {
  const TrackingEyeWidget({
    super.key,
    required this.pointerPosition,
    required this.onActivated,
    this.pauseTracking = false,
  });

  final ValueNotifier<Offset> pointerPosition;
  final VoidCallback onActivated;
  final bool pauseTracking;

  @override
  State<TrackingEyeWidget> createState() => TrackingEyeWidgetState();
}

class TrackingEyeWidgetState extends State<TrackingEyeWidget>
    with TickerProviderStateMixin {
  final _eyeKey = GlobalKey();
  late final AnimationController _lidController;
  late final AnimationController _floatController;
  late final Animation<double> _lidCurve;

  Offset _pupilOffset = Offset.zero;
  bool _isAnimating = false;
  bool _hasBeenClicked = false;
  bool _cursorNearEye = false;
  int _stopMemeIndex = 0;
  Timer? _idleBlinkTimer;
  Timer? _warningTimer;
  Timer? _idleChatTimer;
  Timer? _stopMemeTimer;
  _EyeSpeechPhase _speechPhase = _EyeSpeechPhase.none;
  bool _showIdleChat = false;
  int _idleMessageIndex = 0;

  double get _lidAmount => _lidCurve.value;
  bool get _isClosed => _lidAmount > 0.92;

  @override
  void initState() {
    super.initState();
    _lidController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _lidCurve = CurvedAnimation(
      parent: _lidController,
      curve: Curves.easeInOutCubic,
    );
    widget.pointerPosition.addListener(_handlePointerMove);
    _startIdleBlink();
    _scheduleWarning();
    _startIdleChat();
  }

  @override
  void didUpdateWidget(covariant TrackingEyeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pauseTracking && !widget.pauseTracking) {
      _openEye();
      _hasBeenClicked = false;
      _scheduleWarning();
      _startIdleChat();
    } else if (!oldWidget.pauseTracking && widget.pauseTracking) {
      _idleBlinkTimer?.cancel();
      _warningTimer?.cancel();
      _idleChatTimer?.cancel();
      _stopMemeTimer?.cancel();
      setState(() {
        _speechPhase = _EyeSpeechPhase.none;
        _showIdleChat = false;
      });
    }
  }

  @override
  void dispose() {
    _idleBlinkTimer?.cancel();
    _warningTimer?.cancel();
    _idleChatTimer?.cancel();
    _stopMemeTimer?.cancel();
    widget.pointerPosition.removeListener(_handlePointerMove);
    _lidController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _scheduleWarning() {
    _warningTimer?.cancel();
    _warningTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted || _hasBeenClicked || widget.pauseTracking) return;
      _showWarning();
    });
  }

  void _scheduleNextWarning() {
    _warningTimer?.cancel();
    if (!mounted || _hasBeenClicked || widget.pauseTracking) return;
    _warningTimer = Timer(const Duration(seconds: 10), () {
      if (!mounted || _hasBeenClicked || widget.pauseTracking) return;
      _showWarning();
    });
  }

  void _showWarning() {
    setState(() => _speechPhase = _EyeSpeechPhase.dontClick);
    _warningTimer?.cancel();
    _warningTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      if (_speechPhase == _EyeSpeechPhase.dontClick) {
        setState(() => _speechPhase = _EyeSpeechPhase.none);
      }
      _scheduleNextWarning();
    });
  }

  void _startIdleChat() {
    _idleChatTimer?.cancel();
    _scheduleNextIdleChat(delaySeconds: 6);
  }

  void _scheduleNextIdleChat({required int delaySeconds}) {
    _idleChatTimer?.cancel();
    if (!mounted || _hasBeenClicked || widget.pauseTracking) return;

    _idleChatTimer = Timer(Duration(seconds: delaySeconds), () {
      if (!mounted || _hasBeenClicked || widget.pauseTracking) return;
      if (_speechPhase == _EyeSpeechPhase.dontClick) {
        _scheduleNextIdleChat(delaySeconds: 3);
        return;
      }

      setState(() {
        _showIdleChat = true;
        _idleMessageIndex = (_idleMessageIndex + 1) % _idleMessages.length;
      });

      _idleChatTimer = Timer(const Duration(seconds: 4), () {
        if (!mounted) return;
        setState(() => _showIdleChat = false);
        _scheduleNextIdleChat(delaySeconds: 7);
      });
    });
  }

  void _startIdleBlink() {
    _idleBlinkTimer?.cancel();
    _scheduleNextBlink();
  }

  void _scheduleNextBlink() {
    _idleBlinkTimer?.cancel();
    if (!mounted || widget.pauseTracking) return;
    _idleBlinkTimer = Timer(const Duration(seconds: 4), () async {
      if (!mounted || widget.pauseTracking || _isAnimating || _isClosed) {
        _scheduleNextBlink();
        return;
      }
      await _quickBlink();
      _scheduleNextBlink();
    });
  }

  Future<void> _quickBlink() async {
    if (_isAnimating || widget.pauseTracking) return;
    _isAnimating = true;
    await _lidController.animateTo(1, duration: const Duration(milliseconds: 120));
    if (!mounted) return;
    await _lidController.animateTo(0, duration: const Duration(milliseconds: 180));
    _isAnimating = false;
  }

  Future<void> _closeEye() async {
    _isAnimating = true;
    await _lidController.forward();
    _isAnimating = false;
  }

  Future<void> _openEye() async {
    if (_lidController.value <= 0.01) return;
    _isAnimating = true;
    await _lidController.reverse();
    _isAnimating = false;
    if (!widget.pauseTracking) _startIdleBlink();
  }

  void _handlePointerMove() {
    final box = _eyeKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final eyeCenter = box.localToGlobal(box.size.center(Offset.zero));
    final delta = widget.pointerPosition.value - eyeCenter;
    final distance = delta.distance;

    final near = !widget.pauseTracking &&
        !_hasBeenClicked &&
        distance < 150;

    if (near != _cursorNearEye) {
      if (near) {
        _stopMemeIndex = 0;
        _startStopMemeCycle();
      } else {
        _stopMemeTimer?.cancel();
      }
      setState(() => _cursorNearEye = near);
    }

    if (_isAnimating || widget.pauseTracking || _lidAmount > 0.35) return;

    const maxOffset = kEyeSize * 0.17;
    final offset = distance <= maxOffset
        ? delta
        : Offset(
            delta.dx / distance * maxOffset,
            delta.dy / distance * maxOffset,
          );

    if ((offset - _pupilOffset).distance > 0.5) {
      setState(() => _pupilOffset = offset);
    }
  }

  void _startStopMemeCycle() {
    _stopMemeTimer?.cancel();
    _scheduleNextStopMeme();
  }

  void _scheduleNextStopMeme() {
    if (!mounted || !_cursorNearEye || _hasBeenClicked || widget.pauseTracking) {
      return;
    }
    _stopMemeTimer = Timer(const Duration(milliseconds: 1600), () {
      if (!mounted || !_cursorNearEye) return;
      setState(() {
        _stopMemeIndex = (_stopMemeIndex + 1) % _stopMemeMessages.length;
      });
      _scheduleNextStopMeme();
    });
  }

  Future<void> _onEyeTap() async {
    if (_isAnimating) return;

    if (_isClosed) {
      await _openEye();
      setState(() {
        _speechPhase = _EyeSpeechPhase.none;
        _cursorNearEye = false;
      });
      return;
    }

    _hasBeenClicked = true;
    _warningTimer?.cancel();
    _idleChatTimer?.cancel();
    _stopMemeTimer?.cancel();
    _idleBlinkTimer?.cancel();
    setState(() {
      _speechPhase = _EyeSpeechPhase.none;
      _cursorNearEye = false;
      _showIdleChat = false;
    });

    await _closeEye();
    if (!mounted) return;
    widget.onActivated();
  }

  @override
  Widget build(BuildContext context) {
    final idleMsg = _showIdleChat ? _idleMessages[_idleMessageIndex] : null;

    return SizedBox(
      width: kEyeSize + 200,
      height: kEyeSize + 120,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          if (_speechPhase == _EyeSpeechPhase.dontClick) ...[
            _positionedBubble(
              left: 28,
              bottom: kEyeSize + 6,
              floatOffset: 0,
              tail: _BubbleTail.bottom,
              text: "Don't you DARE click 👁️",
              style: _CoolBubbleStyle.neon,
            ),
            _positionedBubble(
              left: -118,
              bottom: 36,
              floatOffset: 0.4,
              tail: _BubbleTail.right,
              text: 'Sus behavior 🚨',
              style: _CoolBubbleStyle.purple,
            ),
          ],
          if (_cursorNearEye)
            _positionedBubble(
              key: ValueKey(_stopMemeMessages[_stopMemeIndex]),
              left: kEyeSize + 6,
              bottom: 44,
              floatOffset: 0.8,
              tail: _BubbleTail.left,
              text: _stopMemeMessages[_stopMemeIndex],
              style: _CoolBubbleStyle.warning,
            ),
          if (idleMsg != null && _speechPhase != _EyeSpeechPhase.dontClick)
            _positionedBubble(
              key: ValueKey(idleMsg.text),
              left: idleMsg.left,
              bottom: idleMsg.bottom,
              floatOffset: idleMsg.floatOffset,
              tail: idleMsg.tail,
              text: idleMsg.text,
              style: idleMsg.style,
            ),
          Positioned(
            left: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _onEyeTap,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedBuilder(
                  animation: _lidCurve,
                  builder: (context, child) {
                    return CustomPaint(
                      key: _eyeKey,
                      size: const Size(kEyeSize, kEyeSize),
                      painter: _CartoonEyePainter(
                        pupilOffset: _pupilOffset,
                        lidAmount: _lidAmount,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _positionedBubble({
    Key? key,
    required double left,
    required double bottom,
    required double floatOffset,
    required _BubbleTail tail,
    required String text,
    required _CoolBubbleStyle style,
  }) {
    return Positioned(
      key: key,
      left: left,
      bottom: bottom,
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 200),
        child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final bob = math.sin((_floatController.value + floatOffset) * math.pi) * 5;
          return Transform.translate(offset: Offset(0, bob), child: child);
        },
        child: _CoolSpeechBubble(
          text: text,
          tail: tail,
          style: style,
        ),
        ),
      ),
    );
  }
}

class _CoolSpeechBubble extends StatelessWidget {
  const _CoolSpeechBubble({
    required this.text,
    required this.tail,
    required this.style,
  });

  final String text;
  final _BubbleTail tail;
  final _CoolBubbleStyle style;

  @override
  Widget build(BuildContext context) {
    final (bg, border, glow) = switch (style) {
      _CoolBubbleStyle.neon => (
          AppTheme.neon,
          AppTheme.black,
          AppTheme.neon.withValues(alpha: 0.55),
        ),
      _CoolBubbleStyle.purple => (
          AppTheme.purple,
          AppTheme.black,
          AppTheme.purple.withValues(alpha: 0.5),
        ),
      _CoolBubbleStyle.white => (
          AppTheme.white,
          AppTheme.black,
          AppTheme.white.withValues(alpha: 0.4),
        ),
      _CoolBubbleStyle.warning => (
          const Color(0xFFFF3B30),
          AppTheme.black,
          const Color(0xFFFF3B30).withValues(alpha: 0.55),
        ),
    };

    return CustomPaint(
      painter: _BubbleTailPainter(tail: tail, fill: bg, border: border),
      child: Container(
        margin: _tailMargin(tail),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 160),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: glow, blurRadius: 18, spreadRadius: 1),
            BoxShadow(
              color: AppTheme.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: switch (style) {
              _CoolBubbleStyle.neon => AppTheme.black,
              _CoolBubbleStyle.purple => AppTheme.white,
              _CoolBubbleStyle.white => AppTheme.black,
              _CoolBubbleStyle.warning => AppTheme.white,
            },
            height: 1.25,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  EdgeInsets _tailMargin(_BubbleTail tail) {
    return switch (tail) {
      _BubbleTail.top => const EdgeInsets.only(top: 10),
      _BubbleTail.bottom => const EdgeInsets.only(bottom: 10),
      _BubbleTail.left => const EdgeInsets.only(left: 10),
      _BubbleTail.right => const EdgeInsets.only(right: 10),
    };
  }
}

class _BubbleTailPainter extends CustomPainter {
  _BubbleTailPainter({
    required this.tail,
    required this.fill,
    required this.border,
  });

  final _BubbleTail tail;
  final Color fill;
  final Color border;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      tail == _BubbleTail.left ? 10 : 0,
      tail == _BubbleTail.top ? 10 : 0,
      size.width - (tail == _BubbleTail.left || tail == _BubbleTail.right ? 10 : 0),
      size.height - (tail == _BubbleTail.top || tail == _BubbleTail.bottom ? 10 : 0),
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));

    canvas.drawRRect(rrect, Paint()..color = fill);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final tailPath = Path();
    switch (tail) {
      case _BubbleTail.bottom:
        tailPath
          ..moveTo(size.width * 0.45, rect.bottom)
          ..lineTo(size.width * 0.38, size.height)
          ..lineTo(size.width * 0.55, rect.bottom);
      case _BubbleTail.top:
        tailPath
          ..moveTo(size.width * 0.5, rect.top)
          ..lineTo(size.width * 0.42, 0)
          ..lineTo(size.width * 0.58, rect.top);
      case _BubbleTail.left:
        tailPath
          ..moveTo(rect.left, size.height * 0.55)
          ..lineTo(0, size.height * 0.62)
          ..lineTo(rect.left, size.height * 0.72);
      case _BubbleTail.right:
        tailPath
          ..moveTo(rect.right, size.height * 0.5)
          ..lineTo(size.width, size.height * 0.58)
          ..lineTo(rect.right, size.height * 0.68);
    }

    canvas.drawPath(tailPath, Paint()..color = fill);
    canvas.drawPath(
      tailPath,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) => false;
}

class _CartoonEyePainter extends CustomPainter {
  _CartoonEyePainter({
    required this.pupilOffset,
    required this.lidAmount,
  });

  final Offset pupilOffset;
  final double lidAmount;

  static const _irisColor = Color(0xFFADB8C4);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final outline = Paint()
      ..color = AppTheme.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, outline);

    final topLidY = center.dy - radius + (radius * 1.85 * lidAmount);
    final bottomLidY = center.dy + radius - (radius * 0.55 * lidAmount);

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, topLidY, size.width, bottomLidY));

    canvas.drawCircle(center, radius - 5, Paint()..color = AppTheme.white);

    if (lidAmount < 0.85) {
      final irisCenter = center + pupilOffset * (1 - lidAmount * 0.5);
      canvas.drawCircle(
        irisCenter,
        radius * 0.38 * (1 - lidAmount * 0.3),
        Paint()..color = _irisColor,
      );
      canvas.drawCircle(
        irisCenter,
        radius * 0.2 * (1 - lidAmount * 0.3),
        Paint()..color = AppTheme.black,
      );
      canvas.drawCircle(
        irisCenter + Offset(radius * 0.1, -radius * 0.12),
        radius * 0.055,
        Paint()..color = AppTheme.white,
      );
    }

    canvas.restore();

    final lidPaint = Paint()
      ..color = AppTheme.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    final openLidY = center.dy - radius * 0.52;
    final closedLidY = center.dy + radius * 0.05;
    final upperLidY = openLidY + (closedLidY - openLidY) * lidAmount;

    canvas.drawLine(
      Offset(center.dx - radius + 6, upperLidY),
      Offset(center.dx + radius - 6, upperLidY),
      lidPaint,
    );

    if (lidAmount > 0.08) {
      final openBottomY = center.dy + radius * 0.72;
      final closedBottomY = center.dy + radius * 0.05;
      final lowerLidY = openBottomY + (closedBottomY - openBottomY) * lidAmount;

      canvas.drawLine(
        Offset(center.dx - radius + 10, lowerLidY),
        Offset(center.dx + radius - 10, lowerLidY),
        lidPaint..strokeWidth = 7,
      );
    }

    if (lidAmount > 0.92) {
      canvas.drawLine(
        Offset(center.dx - radius + 4, center.dy),
        Offset(center.dx + radius - 4, center.dy),
        lidPaint..strokeWidth = 10,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CartoonEyePainter oldDelegate) {
    return oldDelegate.pupilOffset != pupilOffset ||
        (oldDelegate.lidAmount - lidAmount).abs() > 0.01;
  }
}

enum _HireMeStep { brokeEye, hireMeSmile }

/// Full-screen overlay — broke eye message, then hire me, then contact.
class HireMeOverlay extends StatefulWidget {
  const HireMeOverlay({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<HireMeOverlay> createState() => _HireMeOverlayState();
}

class _HireMeOverlayState extends State<HireMeOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  _HireMeStep _step = _HireMeStep.brokeEye;
  Timer? _stepTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _stepTimer = Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      setState(() => _step = _HireMeStep.hireMeSmile);
      _controller.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_step == _HireMeStep.brokeEye) {
      _stepTimer?.cancel();
      setState(() => _step = _HireMeStep.hireMeSmile);
      _controller.forward(from: 0);
      return;
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 600;

    return Material(
      color: AppTheme.black.withValues(alpha: 0.78),
      child: InkWell(
        onTap: _handleTap,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = Curves.easeOutBack.transform(_controller.value);
              return Opacity(
                opacity: Curves.easeOut.transform(_controller.value),
                child: Transform.scale(scale: 0.7 + t * 0.3, child: child),
              );
            },
            child: _step == _HireMeStep.brokeEye
                ? _OverlayBubble(
                    isCompact: isCompact,
                    title: 'Oh! No, you broke my eye!',
                    subtitle: 'Tap to continue...',
                    style: _CoolBubbleStyle.purple,
                    large: true,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _OverlayBubble(
                        isCompact: isCompact,
                        title: 'You did wrong to me.',
                        subtitle: 'Now hire me 😊',
                        style: _CoolBubbleStyle.neon,
                        large: false,
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 36 : 56,
                          vertical: isCompact ? 22 : 32,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.neon,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.black, width: 5),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neon.withValues(alpha: 0.5),
                              blurRadius: 36,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          'HIRE ME 😊',
                          style: TextStyle(
                            fontSize: isCompact ? 44 : 72,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.black,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tap to view contact',
                        style: TextStyle(
                          color: AppTheme.white.withValues(alpha: 0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _OverlayBubble extends StatelessWidget {
  const _OverlayBubble({
    required this.isCompact,
    required this.title,
    required this.subtitle,
    required this.style,
    required this.large,
  });

  final bool isCompact;
  final String title;
  final String subtitle;
  final _CoolBubbleStyle style;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final (bg, border, glow) = switch (style) {
      _CoolBubbleStyle.neon => (
          AppTheme.neon,
          AppTheme.black,
          AppTheme.neon.withValues(alpha: 0.6),
        ),
      _CoolBubbleStyle.purple => (
          AppTheme.purple,
          AppTheme.black,
          AppTheme.purple.withValues(alpha: 0.55),
        ),
      _CoolBubbleStyle.white => (
          AppTheme.white,
          AppTheme.black,
          AppTheme.white.withValues(alpha: 0.4),
        ),
      _CoolBubbleStyle.warning => (
          const Color(0xFFFF3B30),
          AppTheme.black,
          const Color(0xFFFF3B30).withValues(alpha: 0.55),
        ),
    };

    return Container(
      constraints: BoxConstraints(maxWidth: isCompact ? 300 : 480),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 28 : 40,
        vertical: isCompact ? 24 : 32,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border, width: 5),
        boxShadow: [
          BoxShadow(color: glow, blurRadius: 40, spreadRadius: 6),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: large ? (isCompact ? 26 : 36) : (isCompact ? 22 : 28),
              fontWeight: FontWeight.w900,
              color: style == _CoolBubbleStyle.neon ? AppTheme.black : AppTheme.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isCompact ? 14 : 16,
              fontWeight: FontWeight.w700,
              color: style == _CoolBubbleStyle.neon
                  ? AppTheme.black.withValues(alpha: 0.65)
                  : AppTheme.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
