import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/motion/feedback_spec.dart';

/// A plain sheet rise. The face is the star, so this stays out of the way.
class SheetRise extends ChangeNotifier {
  SheetRise({required TickerProvider vsync}) {
    _motion = AnimationController(vsync: vsync, value: 0, debugLabel: 'feedback-sheet')
      ..addListener(notifyListeners);
  }

  late final AnimationController _motion;
  double? _goal;
  var reduced = false;

  double get t => _motion.value.clamp(0.0, 1.0);
  bool get isAnimating => _motion.isAnimating;
  bool get closed => t <= 0.001 && !isAnimating;
  bool get settled => t >= 0.999 && !isAnimating && _goal == 1;

  void open() {
    if (_goal == 1 && (isAnimating || t >= 0.999)) return;
    _goal = 1;
    _go(1, FeedbackSpec.open, Curves.easeOutCubic);
  }

  void close() {
    if (_goal == 0 && (isAnimating || t <= 0.001)) return;
    _goal = 0;
    _go(0, FeedbackSpec.close, Curves.easeInCubic);
  }

  void _go(double target, Duration duration, Curve curve) {
    _motion.stop();
    if (reduced) {
      _motion.animateTo(target, duration: FeedbackSpec.reduced, curve: Curves.easeOut);
      return;
    }
    _motion.animateTo(target, duration: duration, curve: curve);
    notifyListeners();
  }

  void dragBy(double dy, double travel) {
    if (travel <= 1) return;
    _motion.stop();
    _goal = null;
    _motion.value = (t - dy * FeedbackSpec.dragResistance / travel).clamp(0.0, 1.0);
  }

  void endDrag(double vy, double travel) {
    if (travel <= 1) return;
    final flickDown = vy > FeedbackSpec.sheetFlick;
    final flickUp = vy < -FeedbackSpec.sheetFlick;
    final target = flickDown ? 0.0 : (flickUp ? 1.0 : (t < FeedbackSpec.dismissAt ? 0.0 : 1.0));
    _goal = target;
    if (reduced) {
      _motion.animateTo(target, duration: FeedbackSpec.reduced, curve: Curves.easeOut);
      return;
    }
    var velocity = (-vy / travel).clamp(-3.4, 3.4);
    if ((target - t) * velocity < 0) velocity = 0;
    _motion.animateWith(
      SpringSimulation(
        FeedbackSpec.sheetSpring,
        t,
        target,
        velocity,
        snapToEnd: true,
        tolerance: const Tolerance(velocity: 0.02, distance: 0.001),
      ),
    );
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }
}
