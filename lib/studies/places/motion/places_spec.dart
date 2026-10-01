import 'package:flutter/physics.dart';

/// Knobs for the card flight. Tune these on a phone.
abstract final class PlacesSpec {
  static const cardRadius = 28.0;
  static const liftRadius = 36.0;
  static const liftScale = 0.86;
  static const liftTravel = 320.0;
  static const commitFraction = 0.22;
  static const flick = 700.0;
  static const sideFollow = 0.85;
  static const gutter = 20.0;
  static const gap = 22.0;
  static const imageTall = 1.08;
  static const pressScale = 0.98;
  static const listRest = 0.96;
  static const scrimPeak = 0.12;
  static const sheetOverlap = 28.0;
  static const tintMix = 0.05;
  static const cardParallax = 0.12;
  static const heroFraction = 0.535;
  static const heroFractionCompact = 0.45;
  static const compactHeight = 700.0;
  static const bodyStart = 0.60;
  static const bodyEnd = 0.86;
  static const closeStart = 0.82;
  static const closeEnd = 1.0;
  static const titleCard = 20.0;
  static const titlePage = 30.0;
  static const metaCard = 14.0;
  static const metaPage = 15.0;
  static const bodyRise = 12.0;
  static const parallax = 0.5;
  static const padCard = 18.0;
  static const padPage = 20.0;
  static const edgeWidth = 24.0;
  static const edgeShift = 0.28;

  static const reduced = Duration(milliseconds: 200);

  static final openSpring = SpringDescription.withDurationAndBounce(
    duration: const Duration(milliseconds: 520),
    bounce: 0,
  );
  static final closeSpring = SpringDescription.withDurationAndBounce(
    duration: const Duration(milliseconds: 420),
    bounce: 0,
  );

  static double heroHeight(double screenHeight) {
    final fraction = screenHeight < compactHeight
        ? heroFractionCompact
        : heroFraction;
    return screenHeight * fraction;
  }

  /// 0 before [start], 1 after [end], easing in between.
  static double fade(double t, double start, double end) {
    if (t <= start) return 0;
    if (t >= end) return 1;
    final u = (t - start) / (end - start);
    final curved = u * u * (3 - 2 * u);
    return curved.clamp(0.0, 1.0);
  }

  /// Body groups arrive 45ms apart once the page is mostly open.
  static double stagger(double t, int index) {
    const step = 45 / 520;
    final start = bodyStart + index * step;
    return fade(t, start, start + 0.2);
  }
}
