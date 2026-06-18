import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// Damped pendulum driven by scroll velocity for natural web swing.
class WebPhysicsSimulator extends ChangeNotifier {
  double angle = 0;
  double angularVelocity = 0;
  double stretch = 0;

  static const _spring = 0.065;
  static const _damping = 0.88;
  static const _maxAngle = 0.42;

  void step({
    required double dt,
    required double scrollVelocity,
  }) {
    final clampedDt = dt.clamp(0.001, 0.05);
    final impulse = scrollVelocity * 0.0045;

    angularVelocity += (-_spring * angle) + impulse;
    angularVelocity *= math.pow(_damping, clampedDt * 60).toDouble();
    angle += angularVelocity * clampedDt * 60;
    angle = angle.clamp(-_maxAngle, _maxAngle);

    final targetStretch = scrollVelocity.abs() * 0.08;
    stretch += (targetStretch - stretch) * (1 - math.pow(0.82, clampedDt * 60));
    notifyListeners();
  }

  double get swingOffset => angle * 120;
  double get stretchFactor => 1 + stretch * 0.015;
}
