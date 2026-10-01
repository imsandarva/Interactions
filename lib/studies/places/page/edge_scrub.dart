import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/motion/place_flight.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';

/// The iOS edge swipe runs the same close as a drag down, shifted with the finger.
class EdgeScrub extends StatefulWidget {
  const EdgeScrub({required this.flight, super.key});

  final PlaceFlight flight;

  @override
  State<EdgeScrub> createState() => _EdgeScrubState();
}

class _EdgeScrubState extends State<EdgeScrub> {
  var _dx = 0.0;

  void _update(double delta) {
    _dx += delta;
    final width = widget.flight.screen.width;
    final travel = width < 1 ? 1.0 : width;
    final u = (_dx.abs() / (travel * 0.55)).clamp(0.0, 1.0);
    widget.flight.edgeTo(u, _dx * 0.55);
  }

  void _end(double vx) {
    final width = widget.flight.screen.width;
    final travel = width < 1 ? 1.0 : width;
    final u = (_dx.abs() / (travel * 0.55)).clamp(0.0, 1.0);
    final commit =
        vx > PlacesSpec.flick || (vx > -PlacesSpec.flick && u > 0.33);
    widget.flight.endEdge(
      commit: commit,
      speed: (vx.abs() / 480).clamp(0.0, 6.0),
    );
    _dx = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (_) => _dx = 0,
      onHorizontalDragUpdate: (details) => _update(details.delta.dx),
      onHorizontalDragEnd: (details) =>
          _end(details.velocity.pixelsPerSecond.dx),
    );
  }
}
