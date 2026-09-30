import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/payment/motion/pay_timing.dart';

/// One progress value from pill (0) to sheet (1). Drag, tap, and back all
/// drive this, so the motion can reverse from wherever it is.
class PayMorph extends ChangeNotifier {
  PayMorph({required TickerProvider vsync}) {
    _motion = AnimationController(vsync: vsync, value: 0, debugLabel: 'pay-morph')
      ..addListener(notifyListeners)
      ..addStatusListener(_status);
    _stretch = AnimationController(
      vsync: vsync,
      lowerBound: 0,
      upperBound: 56,
      value: 0,
      debugLabel: 'pay-stretch',
    )..addListener(notifyListeners);
  }

  late final AnimationController _motion;
  late final AnimationController _stretch;
  double? _goal;
  var _armSettle = false;

  double get t => _motion.value.clamp(0.0, 1.0);
  double get stretch => _stretch.value;
  bool get isClosing => _goal == 0 && _motion.isAnimating;
  bool get canLeave => t <= 0.001 && !_motion.isAnimating;
  bool reduced = false;

  void open() {
    if (_goal == 1 && _motion.isAnimating) return;
    if (t >= 0.999 && !_motion.isAnimating) return;
    _goal = 1;
    _armSettle = true;
    _releaseStretch();
    if (reduced) {
      _motion.animateTo(1, duration: PayTiming.reduced, curve: Curves.easeOut);
      return;
    }
    final current = _motion.isAnimating ? _motion.velocity : 0.0;
    final kick = current.abs() < 0.2 ? PayTiming.openKick : current;
    _motion.animateWith(_spring(PayTiming.openSpring, 1, kick));
  }

  void close() {
    if (_goal == 0 && _motion.isAnimating) return;
    if (t <= 0.001 && !_motion.isAnimating) return;
    _goal = 0;
    _armSettle = false;
    _releaseStretch();
    if (reduced) {
      _motion.animateTo(0, duration: PayTiming.reduced, curve: Curves.easeOut);
      return;
    }
    final current = _motion.isAnimating ? _motion.velocity : 0.0;
    final kick = current.abs() < 0.2 ? -PayTiming.closeKick : current;
    _motion.animateBackWith(_spring(PayTiming.closeSpring, 0, kick));
  }

  void dragBy(double dy, double travel) {
    if (travel <= 1) return;
    _motion.stop();
    _stretch.stop();
    _goal = null;
    _armSettle = false;
    if (t >= 0.999 && dy < 0) {
      _stretch.value = (_stretch.value - dy * 0.22).clamp(0.0, 56.0);
      return;
    }
    if (_stretch.value > 0) {
      _stretch.value = (_stretch.value - dy).clamp(0.0, 56.0);
      if (_stretch.value > 0) return;
    }
    _motion.value = (t - dy * PayTiming.dragResistance / travel).clamp(0.0, 1.0);
  }

  void endDrag(double vy, double travel) {
    if (travel <= 1) {
      _releaseStretch();
      return;
    }
    final flickDown = vy > PayTiming.flick;
    final flickUp = vy < -PayTiming.flick;
    final target = flickDown
        ? 0.0
        : flickUp
        ? 1.0
        : (t < PayTiming.settleThreshold ? 0.0 : 1.0);
    final settled = (target - t).abs() < 0.012;
    _releaseStretch();
    if (settled) {
      _goal = target;
      if ((t - target).abs() > 0.0001) _motion.value = target;
      return;
    }
    _goal = target;
    _armSettle = target == 1;
    final velocity = (-vy / travel).clamp(-3.2, 3.2);
    final spring = target == 1 ? PayTiming.openSpring : PayTiming.closeSpring;
    final simulation = _spring(spring, target, velocity);
    if (target == 1) {
      _motion.animateWith(simulation);
    } else {
      _motion.animateBackWith(simulation);
    }
  }

  void _releaseStretch() {
    if (_stretch.value == 0) return;
    _stretch.animateTo(0, duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
  }

  SpringSimulation _spring(SpringDescription spring, double target, double velocity) {
    return SpringSimulation(
      spring,
      t,
      target,
      velocity,
      snapToEnd: true,
      tolerance: const Tolerance(velocity: 0.02, distance: 0.001),
    );
  }

  void _status(AnimationStatus status) {
    if (status == AnimationStatus.completed && _armSettle) {
      _armSettle = false;
      HapticFeedback.selectionClick();
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    _stretch.dispose();
    super.dispose();
  }
}
