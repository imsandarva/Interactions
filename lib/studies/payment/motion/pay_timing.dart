import 'package:flutter/physics.dart';

/// Knobs for the morph. Open should answer immediately and settle softly.
abstract final class PayTiming {
  static const reduced = Duration(milliseconds: 170);

  /// Perceptual length. A zero bounce is critically damped: no visible rebound.
  static final openSpring = SpringDescription.withDurationAndBounce(
    duration: const Duration(milliseconds: 520),
    bounce: 0,
  );
  static final closeSpring = SpringDescription.withDurationAndBounce(
    duration: const Duration(milliseconds: 400),
    bounce: 0,
  );

  /// Progress per second, injected when a gesture starts from rest so the
  /// spring does not sit still for the first frames.
  static const openKick = 2.4;
  static const closeKick = 2.8;

  /// Finger pixels to sheet pixels. A hair under 1:1, so the drag has weight.
  static const dragResistance = 0.94;
  static const flick = 850.0;
  static const settleThreshold = 0.66;
  static const pressScale = 0.97;
}
