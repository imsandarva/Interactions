import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/motion/place_flight.dart';

/// Pull down to dismiss, only when a new drag starts at the top of the page.
///
/// Reaching the top inside a scroll does not dismiss. Catching the page
/// mid-flight pauses it, and a still finger lets the spring continue.
class PageDrag extends StatefulWidget {
  const PageDrag({
    required this.flight,
    required this.scroll,
    required this.child,
    super.key,
  });

  final PlaceFlight flight;
  final ScrollController scroll;
  final Widget child;

  @override
  State<PageDrag> createState() => _PageDragState();
}

class _PageDragState extends State<PageDrag> {
  var _tracking = false;
  var _armed = false;
  var _paused = false;
  var _moved = false;
  Offset? _origin;
  VelocityTracker? _tracker;

  bool get _atTop => !widget.scroll.hasClients || widget.scroll.offset <= 1;

  void _down(PointerDownEvent event) {
    if (widget.flight.scrubbing) return;
    _tracking = true;
    _moved = false;
    _origin = event.position;
    _tracker = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.position);
    if (!widget.flight.settledOpen) {
      widget.flight.hold();
      _paused = true;
      _armed = false;
      return;
    }
    _paused = false;
    _armed = _atTop;
  }

  void _move(PointerMoveEvent event) {
    if (!_tracking || widget.flight.scrubbing) return;
    _tracker?.addPosition(event.timeStamp, event.position);
    final origin = _origin;
    if (origin == null) return;
    final total = event.position - origin;
    if (!_moved) {
      if (total.distance < 8) return;
      final vertical = total.dy.abs() > total.dx.abs();
      if (!vertical || (!_paused && (!_armed || total.dy <= 0))) {
        if (_paused) widget.flight.resume();
        _tracking = false;
        _paused = false;
        _armed = false;
        return;
      }
      _moved = true;
      if (_paused) {
        widget.flight.dragBy(total.dx, total.dy);
      } else {
        widget.flight.beginSettledDrag();
        widget.flight.dragBy(total.dx, total.dy);
      }
      return;
    }
    widget.flight.dragBy(event.delta.dx, event.delta.dy);
  }

  void _up(PointerEvent event) {
    if (!_tracking) return;
    _tracker?.addPosition(event.timeStamp, event.position);
    final vy = _tracker?.getVelocity().pixelsPerSecond.dy ?? 0;
    final paused = _paused;
    final moved = _moved;
    _tracking = false;
    _paused = false;
    _armed = false;
    if (paused && !moved) {
      widget.flight.resume();
      return;
    }
    if (moved) widget.flight.endDrag(vy);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _down,
      onPointerMove: _move,
      onPointerUp: _up,
      onPointerCancel: _up,
      child: widget.child,
    );
  }
}
