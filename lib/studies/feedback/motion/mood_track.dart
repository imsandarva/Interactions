import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/mood/mood.dart';
import 'package:interactions/studies/feedback/motion/feedback_spec.dart';

/// One continuous value. The face, the color, the word, and the thumb all read it.
class MoodTrack extends ChangeNotifier {
  MoodTrack({required TickerProvider vsync, required this.onThanks}) {
    _motion = AnimationController.unbounded(vsync: vsync, value: 0.5, debugLabel: 'mood')
      ..addListener(notifyListeners);
    _nudge = AnimationController(vsync: vsync, duration: FeedbackSpec.nudge, debugLabel: 'mood-nudge')
      ..addListener(notifyListeners);
    _hold = AnimationController(vsync: vsync, duration: FeedbackSpec.thanksHold, debugLabel: 'mood-thanks')
      ..addStatusListener(_onHold);
    _motion.addStatusListener(_onSettled);
  }

  final VoidCallback onThanks;
  late final AnimationController _motion;
  late final AnimationController _nudge;
  late final AnimationController _hold;
  Timer? _hintTimer;

  double _goal = 0.5;
  double _travel = 280;
  final _clock = Stopwatch()..start();
  int? _micros;
  var _direction = 0;
  var _touched = false;
  var _dragging = false;
  var _thanks = false;
  var _hinted = false;
  var _armLand = false;
  var reduced = false;

  double get goal => _goal;
  bool get touched => _touched;
  bool get dragging => _dragging;
  bool get thanks => _thanks;
  int get direction => _direction;
  Mood get current => moodAt(value);

  double get value {
    final base = _motion.value.clamp(0.0, 1.0);
    if (_nudge.value == 0) return base;
    final wave = math.sin(_nudge.value * math.pi);
    return (base + wave * (FeedbackSpec.nudgePx / math.max(_travel, 1))).clamp(0.0, 1.0);
  }

  void setTravel(double travel) {
    if (travel > 1) _travel = travel;
  }

  void beginDrag() {
    _markTouched();
    _dragging = true;
    _motion.stop();
    _goal = value;
    _motion.value = _goal;
    _micros = null;
    notifyListeners();
  }

  void moveTo(double raw) {
    final next = raw.clamp(0.0, 1.0);
    final micros = _clock.elapsedMicroseconds;
    final elapsed = _micros == null ? 0.0 : (micros - _micros!) / 1e6;
    _micros = micros;
    final dt = elapsed < 0.001 ? 0.016 : elapsed.clamp(0.001, 0.05);
    final follow = reduced ? 1.0 : 1 - math.exp(-dt / FeedbackSpec.followTau);
    final shown = _motion.value + (next - _motion.value) * follow;
    if ((next - _goal).abs() > 0.0008) _direction = next > _goal ? 1 : -1;
    _goal = next;
    _cross(_motion.value, shown);
    _motion.value = shown.clamp(0.0, 1.0);
  }

  void endDrag(double valuePerSecond) {
    _dragging = false;
    final target = _destination(_goal, valuePerSecond);
    if (target != _goal) _direction = target > _goal ? 1 : -1;
    _springTo(target, valuePerSecond);
    notifyListeners();
  }

  void jumpTo(double stop) {
    _markTouched();
    _dragging = false;
    if (stop != value) _direction = stop > value ? 1 : _direction;
    _springTo(stop.clamp(0.0, 1.0), 0);
  }

  void send() {
    if (!_touched || _thanks) return;
    _thanks = true;
    HapticFeedback.mediumImpact();
    notifyListeners();
    if (reduced) {
      _hold.duration = FeedbackSpec.reduced;
    }
    _hold.forward(from: 0);
  }

  void cancelHint() {
    _hintTimer?.cancel();
    if (_nudge.value == 0 && !_nudge.isAnimating) return;
    _nudge.stop();
    _nudge.value = 0;
    notifyListeners();
  }

  void armHint() {
    if (reduced || _hinted || _touched) return;
    _hinted = true;
    _hintTimer = Timer(FeedbackSpec.hintDelay, () {
      if (_touched || _dragging || reduced) return;
      _nudge.forward(from: 0);
    });
  }

  void reset() {
    _hintTimer?.cancel();
    _nudge.stop();
    _nudge.value = 0;
    _hold.stop();
    _motion.stop();
    _motion.value = 0.5;
    _goal = 0.5;
    _direction = 0;
    _touched = false;
    _dragging = false;
    _thanks = false;
    _hinted = false;
    _armLand = false;
    _micros = null;
    notifyListeners();
  }

  void _markTouched() {
    final was = _touched;
    _touched = true;
    _hintTimer?.cancel();
    if (_nudge.value > 0) {
      _nudge.stop();
      _nudge.value = 0;
    }
    if (!was) notifyListeners();
  }

  double _destination(double from, double velocity) {
    if (velocity > FeedbackSpec.flick) return from < 0.5 - 0.02 ? 0.5 : 1;
    if (velocity < -FeedbackSpec.flick) return from > 0.5 + 0.02 ? 0.5 : 0;
    return nearestMood(from).anchor;
  }

  void _springTo(double target, double velocity) {
    _goal = target;
    _armLand = (value - target).abs() > 0.015;
    _motion.stop();
    if (reduced) {
      _motion.animateTo(target, duration: FeedbackSpec.reduced, curve: Curves.easeOut);
      return;
    }
    _motion.animateWith(
      SpringSimulation(
        FeedbackSpec.settleSpring,
        value,
        target,
        velocity.clamp(-2.4, 2.4),
        snapToEnd: true,
        tolerance: const Tolerance(velocity: 0.02, distance: 0.001),
      ),
    );
  }

  void _onSettled(AnimationStatus status) {
    if (status != AnimationStatus.completed || !_armLand) return;
    _armLand = false;
    HapticFeedback.lightImpact();
  }

  void _cross(double from, double to) {
    if (!_dragging) return;
    for (final stop in const [0.0, 0.5, 1.0]) {
      if (stop == from) continue;
      final lo = math.min(from, to);
      final hi = math.max(from, to);
      if (stop >= lo && stop <= hi) HapticFeedback.selectionClick();
    }
  }

  void _onHold(AnimationStatus status) {
    if (status == AnimationStatus.completed && _thanks) {
      _armLand = false;
      onThanks();
    }
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _motion.removeListener(notifyListeners);
    _nudge.removeListener(notifyListeners);
    _motion.removeStatusListener(_onSettled);
    _hold.removeStatusListener(_onHold);
    _motion.dispose();
    _nudge.dispose();
    _hold.dispose();
    super.dispose();
  }
}
