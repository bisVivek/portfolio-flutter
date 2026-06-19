import 'package:flutter/material.dart';
import 'scroll_trail_effect.dart';
import 'spider_man_roamer.dart';

/// Coordinates intro web-swing + trail, then hands off to free-roaming Spider-Man.
class SpiderManExperience extends StatefulWidget {
  const SpiderManExperience({
    super.key,
    required this.scrollController,
    required this.sectionNodes,
    required this.roamTargets,
    this.paused = false,
  });

  final ScrollController scrollController;
  final List<TrailSectionNode> sectionNodes;
  final List<SpiderRoamTarget> roamTargets;
  final bool paused;

  @override
  State<SpiderManExperience> createState() => _SpiderManExperienceState();
}

class _SpiderManExperienceState extends State<SpiderManExperience> {
  bool _swingComplete = false;
  Offset _handoffPosition = Offset.zero;

  void _onSwingComplete(Offset spideyPosition) {
    if (_swingComplete) return;
    setState(() {
      _swingComplete = true;
      _handoffPosition = spideyPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_swingComplete) {
      return SpiderManRoamer(
        targets: widget.roamTargets,
        startPosition: _handoffPosition,
        paused: widget.paused,
      );
    }

    return ScrollTrailEffect(
      scrollController: widget.scrollController,
      sectionNodes: widget.sectionNodes,
      onSwingComplete: _onSwingComplete,
    );
  }
}
