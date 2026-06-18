import 'package:flutter/material.dart';

/// Subtle scale + lift on hover — web & desktop.
class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.scale = 1.02,
  });

  final Widget child;
  final double scale;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translateByDouble(0.0, _hovering ? -6.0 : 0.0, 0.0, 1.0),
        child: AnimatedScale(
          scale: _hovering ? widget.scale : 1.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}
