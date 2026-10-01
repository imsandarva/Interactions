import 'dart:math' as math;

/// One expression. Every field is a fraction of the sheet width, except [tilt] in radians.
class FacePose {
  const FacePose({
    required this.eyeW,
    required this.eyeH,
    required this.gap,
    required this.eyeY,
    required this.tilt,
    required this.mouthW,
    required this.mouthCurve,
    required this.mouthY,
    required this.posture,
  });

  final double eyeW;
  final double eyeH;
  final double gap;
  final double eyeY;
  final double tilt;
  final double mouthW;
  final double mouthCurve;
  final double mouthY;
  final double posture;

  /// Wide round eyes, a small smile, sitting a little high.
  static const great = FacePose(
    eyeW: 0.18,
    eyeH: 0.18,
    gap: 0.05,
    eyeY: -0.012,
    tilt: 0,
    mouthW: 0.09,
    mouthCurve: 0.032,
    mouthY: 0.125,
    posture: -0.012,
  );

  /// Relaxed pills and a nearly flat mouth. This is the face at rest.
  static const fine = FacePose(
    eyeW: 0.225,
    eyeH: 0.09,
    gap: 0.02,
    eyeY: 0,
    tilt: 0,
    mouthW: 0.052,
    mouthCurve: -0.006,
    mouthY: 0.108,
    posture: 0,
  );

  /// Smaller tilted eyes and a frown, sitting a little low.
  static const bad = FacePose(
    eyeW: 0.145,
    eyeH: 0.108,
    gap: 0.012,
    eyeY: 0.02,
    tilt: 0.40,
    mouthW: 0.118,
    mouthCurve: -0.042,
    mouthY: 0.118,
    posture: 0.014,
  );

  static FacePose lerp(FacePose a, FacePose b, double t) {
    double m(double from, double to) => from + (to - from) * t;
    return FacePose(
      eyeW: m(a.eyeW, b.eyeW),
      eyeH: m(a.eyeH, b.eyeH),
      gap: m(a.gap, b.gap),
      eyeY: m(a.eyeY, b.eyeY),
      tilt: m(a.tilt, b.tilt),
      mouthW: m(a.mouthW, b.mouthW),
      mouthCurve: m(a.mouthCurve, b.mouthCurve),
      mouthY: m(a.mouthY, b.mouthY),
      posture: m(a.posture, b.posture),
    );
  }

  /// Mouth leads a little, eye tilt trails, and both arrive cleanly on a stop.
  static FacePose compose(double t) {
    final eyes = _at(t);
    final mouth = _at(t, lead: 0.045);
    final tilt = _at(t, lead: -0.04);
    return FacePose(
      eyeW: eyes.eyeW,
      eyeH: eyes.eyeH,
      gap: eyes.gap,
      eyeY: eyes.eyeY,
      tilt: tilt.tilt,
      mouthW: mouth.mouthW,
      mouthCurve: mouth.mouthCurve,
      mouthY: mouth.mouthY,
      posture: eyes.posture,
    );
  }

  static FacePose _at(double t, {double lead = 0}) {
    final x = _shifted(t, lead).clamp(0.0, 1.0);
    if (x <= 0.5) return lerp(bad, fine, _ease(x / 0.5));
    return lerp(fine, great, _ease((x - 0.5) / 0.5));
  }

  /// Lead fades out beside a stop, so a resting pose is never half-formed.
  static double _shifted(double t, double lead) {
    if (lead == 0) return t;
    final gate = (minStopDistance(t) / 0.08).clamp(0.0, 1.0);
    return t + lead * gate;
  }

  static double minStopDistance(double t) {
    final a = t.abs();
    final b = (t - 0.5).abs();
    final c = (t - 1).abs();
    return math.min(a, math.min(b, c));
  }

  /// Midpoint of a segment stays half. The outer 8% of full travel eases into the pose.
  static double _ease(double u) {
    const edge = 0.16;
    const keep = 0.35;
    if (u <= edge) {
      final x = u / edge;
      return _smooth(x) * edge * keep;
    }
    if (u >= 1 - edge) {
      final x = (1 - u) / edge;
      return 1 - _smooth(x) * edge * keep;
    }
    final start = edge * keep;
    final end = 1 - edge * keep;
    return start + (u - edge) / (1 - 2 * edge) * (end - start);
  }

  static double _smooth(double x) => x * x * (3 - 2 * x);
}
