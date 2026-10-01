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
  });

  final Rect bounds;
  final double radius;
  final double layoutT;
  final double scrimT;
  final double shiftY;

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

/// Finger-down from the open page. The first 300px lifts and rounds the page.
/// The rest of the drag scrubs it back into the card.
FlightPose dragPose({
  required double dy,
  required Size screen,
  required Rect card,
}) {
  final travel = dy.clamp(0.0, PlacesSpec.maxTravel);
  if (travel <= PlacesSpec.liftTravel) {
    final u = travel / PlacesSpec.liftTravel;
    final scale = _lerp(1, PlacesSpec.liftScale, u);
    final w = screen.width * scale;
    final h = screen.height * scale;
    final centered = (screen.width - w) / 2;
    final toward = card.center.dx - w / 2;
    final left = _lerp(centered, toward, u * PlacesSpec.xPull);
    return FlightPose(
      bounds: Rect.fromLTWH(left, travel, w, h),
      radius: _lerp(0, PlacesSpec.liftRadius, u),
      layoutT: _lerp(1, 0.5, u),
      scrimT: _lerp(1, 0, u),
    );
  }
  final land = ((travel - PlacesSpec.liftTravel) / PlacesSpec.landTravel).clamp(
    0.0,
    1.0,
  );
  final lift = dragPose(dy: PlacesSpec.liftTravel, screen: screen, card: card);
  return FlightPose(
    bounds: Rect.lerp(lift.bounds, card, land)!,
    radius: _lerp(PlacesSpec.liftRadius, PlacesSpec.cardRadius, land),
    layoutT: _lerp(lift.layoutT, 0, land),
    scrimT: 0,
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
  );
}
