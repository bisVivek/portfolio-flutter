import 'package:flutter/material.dart';

/// Animated counter widget that parses numeric stat values (e.g. "150+", "2+", "50+", "3")
/// and animates counting up from 0 to the target number with easing.
class AnimatedStatCounter extends StatefulWidget {
  const AnimatedStatCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 1600),
    this.delay = Duration.zero,
  });

  final String value;
  final TextStyle? style;
  final Duration duration;
  final Duration delay;

  @override
  State<AnimatedStatCounter> createState() => _AnimatedStatCounterState();
}

class _AnimatedStatCounterState extends State<AnimatedStatCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  late final String _prefix;
  late final double _targetNumber;
  late final String _suffix;
  late final bool _isInteger;

  @override
  void initState() {
    super.initState();
    _parseValue();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  void _parseValue() {
    final regExp = RegExp(r'^([^\d]*)([\d\.]+)(.*)$');
    final match = regExp.firstMatch(widget.value.trim());

    if (match != null) {
      _prefix = match.group(1) ?? '';
      final numStr = match.group(2) ?? '0';
      _suffix = match.group(3) ?? '';

      _targetNumber = double.tryParse(numStr) ?? 0.0;
      _isInteger = !numStr.contains('.');
    } else {
      _prefix = '';
      _targetNumber = 0.0;
      _suffix = widget.value;
      _isInteger = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentVal = _animation.value * _targetNumber;
        final formattedVal = _isInteger
            ? currentVal.round().toString()
            : currentVal.toStringAsFixed(1);

        return Text(
          '$_prefix$formattedVal$_suffix',
          style: widget.style,
        );
      },
    );
  }
}
