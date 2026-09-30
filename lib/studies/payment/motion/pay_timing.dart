import 'package:flutter/physics.dart';

/// Knobs for the morph. Open should answer immediately and settle softly.
abstract final class PayTiming {
  static const reduced = Duration(milliseconds: 170);

  /// Perceptual length. A zero bounce is critically damped: no visible rebound.
  static final openSpring = SpringDescription.withDurationAndBounce(
    duration: const Duration(milliseconds: 720),
    bounce: 0,
  );
  static final closeSpring = SpringDescription.withDurationAndBounce(
    duration: const Duration(milliseconds: 680),
    bounce: 0,
  );

  /// A small shove so the first frame moves, without skipping the stretch.
  /// Close is gentler still, so the collapse into the pill stays on screen.
  static const openKick = 1.0;
  static const closeKick = 1.15;

  /// Finger pixels to sheet pixels. A hair under 1:1, so the drag has weight.
  static const dragResistance = 0.94;
  static const flick = 850.0;
  static const settleThreshold = 0.66;
  static const pressScale = 0.97;
}
