import 'dart:math' as math;
import 'dart:ui';

import 'package:interactions/studies/places/motion/places_spec.dart';

/// Where the flying card is, and how far its contents have opened.
class FlightPose {
  const FlightPose({
    required this.bounds,
    required this.radius,
    required this.layoutT,
    required this.scrimT,
    this.shiftY = 0,
    this.shadow = 0,
  });

  final Rect bounds;
  final double radius;
  final double layoutT;
  final double scrimT;
  final double shiftY;
  final double shadow;

  static FlightPose openOn(Size screen) {
    return FlightPose(
      bounds: Offset.zero & screen,
      radius: 0,
      layoutT: 1,
      scrimT: 1,
    );
  }

  static FlightPose cardOn(Rect card) {
    return FlightPose(
      bounds: card,
      radius: PlacesSpec.cardRadius,
      layoutT: 0,
      scrimT: 0,
    );
  }
}

double _lerp(double a, double b, double t) => a + (b - a) * t;

/// A lifted page following the finger. [dx] is already eased.
FlightPose freeDrag({
  required double dx,
  required double dy,
  required Size screen,
}) {
  final dist = math.sqrt(dx * dx + dy * dy);
  final u = (dist / PlacesSpec.liftTravel).clamp(0.0, 1.0);
  final scale = _lerp(1, PlacesSpec.liftScale, u);
  final w = screen.width * scale;
  final h = screen.height * scale;
  return FlightPose(
    bounds: Rect.fromCenter(
      center: Offset(screen.width / 2 + dx, screen.height / 2 + dy),
      width: w,
      height: h,
    ),
    radius: _lerp(0, PlacesSpec.liftRadius, u),
    layoutT: _lerp(1, 0.42, u),
    scrimT: _lerp(1, 0, u),
    shadow: u,
  );
}

/// Edge and predictive-back preview: the page scales down and shifts aside.
FlightPose edgePose({
  required double u,
  required double shiftX,
  required Size screen,
}) {
  final t = u.clamp(0.0, 1.0);
  final scale = _lerp(1, 0.90, t);
  final w = screen.width * scale;
  final h = screen.height * scale;
  final left = (screen.width - w) / 2 + shiftX;
  final top = _lerp(0, 24, t);
  return FlightPose(
    bounds: Rect.fromLTWH(left, top, w, h),
    radius: _lerp(0, 32, t),
    layoutT: _lerp(1, 0.62, t),
    scrimT: _lerp(1, 0.08, t),
    shadow: t * 0.7,
  );
}
