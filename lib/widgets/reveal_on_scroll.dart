import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Enhanced scroll reveal — fade, slide, scale.
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideOffset = 48,
    this.slideAxis = Axis.vertical,
    this.scaleBegin = 0.88,
  });

  final Widget child;
  final Duration delay;
  final double slideOffset;
  final Axis slideAxis;
  final double scaleBegin;

  @override
  State<RevealOnScroll> createState() => RevealOnScrollState();
}

class RevealOnScrollState extends State<RevealOnScroll> {
  final _key = GlobalKey();
  bool _visible = false;

  void checkVisibility(ScrollController controller) {
    if (_visible) return;
    final context = _key.currentContext;
    if (context == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) return;

    final scrollBox = scrollable.context.findRenderObject() as RenderBox?;
    if (scrollBox == null) return;

    final offset = box.localToGlobal(Offset.zero, ancestor: scrollBox);
    final viewportHeight = scrollBox.size.height;

    if (offset.dy < viewportHeight * 0.92) {
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child
          .animate(target: _visible ? 1 : 0)
          .fadeIn(
            duration: 700.ms,
            delay: widget.delay,
            curve: Curves.easeOutCubic,
          )
          .move(
            begin: widget.slideAxis == Axis.vertical
                ? Offset(0, widget.slideOffset)
                : Offset(widget.slideOffset, 0),
            end: Offset.zero,
            duration: 850.ms,
            delay: widget.delay,
            curve: Curves.easeOutCubic,
          )
          .scale(
            begin: Offset(widget.scaleBegin, widget.scaleBegin),
            end: const Offset(1, 1),
            duration: 850.ms,
            delay: widget.delay,
            curve: Curves.easeOutBack,
          ),
    );
  }
}

class StaggerReveal extends StatelessWidget {
  const StaggerReveal({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = 100,
    this.slideAxis = Axis.vertical,
  });

  final int index;
  final Widget child;
  final int baseDelay;
  final Axis slideAxis;

  @override
  Widget build(BuildContext context) {
    return RevealOnScroll(
      delay: Duration(milliseconds: index * baseDelay),
      slideAxis: slideAxis,
      child: child,
    );
  }
}

class ScrollRevealScope extends StatefulWidget {
  const ScrollRevealScope({
    super.key,
    required this.controller,
    required this.child,
  });

  final ScrollController controller;
  final Widget child;

  @override
  State<ScrollRevealScope> createState() => _ScrollRevealScopeState();
}

class _ScrollRevealScopeState extends State<ScrollRevealScope> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() => _visitRevealNodes(context);

  void _visitRevealNodes(BuildContext context) {
    void visitor(Element element) {
      final state =
          element is StatefulElement ? element.state : null;
      if (state is RevealOnScrollState) {
        state.checkVisibility(widget.controller);
      }
      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
