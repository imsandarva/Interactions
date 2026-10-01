import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/motion/flight_pose.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';

/// The card the page has to return to, measured where it sits.
class PlaceOrigin {
  const PlaceOrigin({
    required this.index,
    required this.rect,
    required this.imageHeight,
  });

  final int index;
  final Rect rect;
  final double imageHeight;
}

enum _Aim { none, open, close }

/// One spring from the card to the page. Drag, close, and back all retarget it.
class PlaceFlight extends ChangeNotifier {
  PlaceFlight({required TickerProvider vsync}) {
    _settle = AnimationController(vsync: vsync, debugLabel: 'place-flight')
      ..addListener(_tick)
      ..addStatusListener(_status);
  }

  late final AnimationController _settle;
  var _bounds = Rect.zero;
  var _radius = PlacesSpec.cardRadius;
  var _layoutT = 0.0;
  var _scrimT = 0.0;
  var _shiftY = 0.0;
  var _active = false;
  var _dragging = false;
  var _holding = false;
  var _edge = false;
  var _fromOpen = false;
  var _button = false;
  var _pastCommit = false;
  var _dragDy = 0.0;
  var _generation = 0;
  var reduced = false;
  _Aim _aim = _Aim.none;
  PlaceOrigin? _origin;
  Size _screen = Size.zero;
  late FlightPose _from;
  late FlightPose _to;
  Rect _grabBounds = Rect.zero;
  var _grabRadius = 0.0;
  var _grabLayout = 0.0;
  var _grabScrim = 0.0;

  Rect get bounds => _bounds;
  double get radius => _radius;
  double get layoutT => _layoutT;
  double get scrimT => _scrimT;
  double get shiftY => _shiftY;
  bool get active => _active;
  bool get dragging => _dragging;
  bool get scrubbing => _edge;
  bool get fromOpen => _fromOpen;
  int get generation => _generation;
  int? get index => _origin?.index;
  PlaceOrigin? get origin => _origin;
  Size get screen => _screen;
  double get heroHeight => PlacesSpec.heroHeight(_screen.height);
  double get listScale => reduced ? 1 : _lerp(1, PlacesSpec.listRest, _scrimT);
  double get scrimAlpha => PlacesSpec.scrimPeak * _scrimT;
  bool get lightStatus => _active && _layoutT > 0.58;

  bool get settledOpen =>
      _active &&
      !_dragging &&
      !_holding &&
      !_edge &&
      !_settle.isAnimating &&
      _layoutT > 0.985 &&
      _aim != _Aim.close;

  void adopt(Size screen) {
    if (screen.width > 1) _screen = screen;
  }

  void setReduced(bool value) {
    if (reduced == value) return;
    reduced = value;
    notifyListeners();
  }

  void open(PlaceOrigin origin, Size screen) {
    if (_active || screen.width < 1 || screen.height < 1) return;
    _generation += 1;
    _origin = origin;
    _screen = screen;
    _active = true;
    _dragging = false;
    _holding = false;
    _edge = false;
    _pastCommit = false;
    _shiftY = 0;
    _apply(FlightPose.cardOn(origin.rect));
    if (reduced) {
      _apply(FlightPose.openOn(screen));
      _layoutT = 0;
      _scrimT = 0;
      notifyListeners();
      _spring(_reducedOpen(), PlacesSpec.openSpring, 0, opening: true);
      return;
    }
    notifyListeners();
    _spring(
      FlightPose.openOn(screen),
      PlacesSpec.openSpring,
      1.2,
      opening: true,
    );
  }

  void close() {
    if (!_active || _origin == null) return;
    _button = false;
    _dragging = false;
    _holding = false;
    _edge = false;
    _spring(_closeTarget(), PlacesSpec.closeSpring, 0.8, opening: false);
  }

  void claim() => _button = true;

  void unclaimAndResume() {
    _button = false;
    if (_dragging) return;
    if (_holding) resume();
  }

  /// Pause a spring where it is, so a finger can catch it.
  void hold() {
    if (!_active) return;
    _settle.stop();
    _holding = true;
    _fromOpen = false;
    _grabBounds = _bounds;
    _grabRadius = _radius;
    _grabLayout = _layoutT;
    _grabScrim = _scrimT;
    _dragDy = 0;
    notifyListeners();
  }

  void beginSettledDrag() {
    _fromOpen = true;
    _dragging = true;
    _holding = false;
    _dragDy = 0;
    _settle.stop();
  }

  void dragBy(double dy) {
    if (!_active || _origin == null) return;
    _dragging = true;
    _holding = false;
    if (reduced) {
      _shiftY = (_shiftY + dy).clamp(0.0, _screen.height * 0.55);
      _dragDy = _shiftY;
      _markCommit(_dragDy);
      notifyListeners();
      return;
    }
    if (_fromOpen) {
      _dragDy = (_dragDy + dy).clamp(0.0, PlacesSpec.maxTravel);
      _apply(dragPose(dy: _dragDy, screen: _screen, card: _origin!.rect));
    } else {
      _dragDy += dy;
      final scale = (1 - _dragDy / 700).clamp(0.82, 1.04);
      _bounds = Rect.fromCenter(
        center: _grabBounds.center + Offset(0, _dragDy),
        width: _grabBounds.width * scale,
        height: _grabBounds.height * scale,
      );
      _radius = (_grabRadius + _dragDy * 0.045).clamp(0.0, 40.0);
      _layoutT = (_grabLayout - _dragDy / 420).clamp(0.0, 1.0);
      _scrimT = (_grabScrim - _dragDy / 360).clamp(0.0, 1.0);
    }
    _markCommit(_fromOpen ? _dragDy : (1 - _layoutT) * PlacesSpec.liftTravel);
    notifyListeners();
  }

  void endDrag(double vy) {
    if (!_active) return;
    _dragging = false;
    _holding = false;
    final flickClose = vy > PlacesSpec.flick;
    final flickOpen = vy < -PlacesSpec.flick;
    final far = _dragDy > PlacesSpec.commitDistance || (1 - _layoutT) > 0.28;
    final closing = flickClose || (!flickOpen && far);
    final speed = (vy.abs() / 520).clamp(0.0, 6.0);
    if (closing) {
      _spring(_closeTarget(), PlacesSpec.closeSpring, speed, opening: false);
    } else {
      _spring(_openTarget(), PlacesSpec.openSpring, speed, opening: true);
    }
  }

  void resume() {
    if (_button || !_active) return;
    _holding = false;
    if (_aim == _Aim.close) {
      _spring(_closeTarget(), PlacesSpec.closeSpring, 0.6, opening: false);
    } else {
      _spring(_openTarget(), PlacesSpec.openSpring, 0.6, opening: true);
    }
  }

  void edgeTo(double u, double shiftX) {
    if (!_active) return;
    _settle.stop();
    _dragging = true;
    _edge = true;
    _holding = false;
    _apply(edgePose(u: u, shiftX: shiftX, screen: _screen));
    notifyListeners();
  }

  void endEdge({required bool commit, required double speed}) {
    if (!_active) return;
    _dragging = false;
    _edge = false;
    if (commit) {
      _spring(_closeTarget(), PlacesSpec.closeSpring, speed, opening: false);
    } else {
      _spring(_openTarget(), PlacesSpec.openSpring, speed, opening: true);
    }
  }

  FlightPose _openTarget() {
    if (reduced) return _reducedOpen();
    return FlightPose.openOn(_screen);
  }

  FlightPose _reducedOpen() {
    return FlightPose(
      bounds: Offset.zero & _screen,
      radius: 0,
      layoutT: 1,
      scrimT: 0.7,
      shiftY: 0,
    );
  }

  FlightPose _closeTarget() {
    final card = _origin!.rect;
    if (reduced) {
      return FlightPose(
        bounds: Offset.zero & _screen,
        radius: 0,
        layoutT: 0,
        scrimT: 0,
        shiftY: _screen.height * 0.18,
      );
    }
    return FlightPose.cardOn(card);
  }

  void _spring(
    FlightPose to,
    SpringDescription spring,
    double velocity, {
    required bool opening,
  }) {
    _from = _current();
    _to = to;
    _aim = opening ? _Aim.open : _Aim.close;
    _holding = false;
    _settle.stop();
    _settle.value = 0;
    if (reduced) {
      _settle.animateTo(1, duration: PlacesSpec.reduced, curve: Curves.easeOut);
      return;
    }
    _settle.animateWith(
      SpringSimulation(
        spring,
        0,
        1,
        velocity.clamp(-6.0, 8.0),
        snapToEnd: true,
        tolerance: const Tolerance(velocity: 0.02, distance: 0.001),
      ),
    );
  }

  void _tick() {
    final s = _settle.value.clamp(0.0, 1.0);
    _bounds = Rect.lerp(_from.bounds, _to.bounds, s)!;
    _radius = _lerp(_from.radius, _to.radius, s);
    _layoutT = _lerp(_from.layoutT, _to.layoutT, s);
    _scrimT = _lerp(_from.scrimT, _to.scrimT, s);
    _shiftY = _lerp(_from.shiftY, _to.shiftY, s);
    notifyListeners();
  }

  void _status(AnimationStatus status) {
    if (status != AnimationStatus.completed || _dragging || _edge) return;
    if (_aim == _Aim.close) _deactivate();
  }

  void _deactivate() {
    _active = false;
    _dragging = false;
    _holding = false;
    _edge = false;
    _aim = _Aim.none;
    _pastCommit = false;
    notifyListeners();
  }

  FlightPose _current() {
    return FlightPose(
      bounds: _safe(_bounds),
      radius: _radius,
      layoutT: _layoutT,
      scrimT: _scrimT,
      shiftY: _shiftY,
    );
  }

  void _apply(FlightPose pose) {
    _bounds = _safe(pose.bounds);
    _radius = pose.radius;
    _layoutT = pose.layoutT;
    _scrimT = pose.scrimT;
    _shiftY = pose.shiftY;
  }

  Rect _safe(Rect rect) {
    return Rect.fromLTWH(
      rect.left,
      rect.top,
      mathMax(rect.width, 1),
      mathMax(rect.height, 1),
    );
  }

  void _markCommit(double distance) {
    final past = distance > PlacesSpec.commitDistance;
    if (past != _pastCommit) HapticFeedback.lightImpact();
    _pastCommit = past;
  }

  @override
  void dispose() {
    _settle.dispose();
    super.dispose();
  }
}

double _lerp(double a, double b, double t) => a + (b - a) * t;

double mathMax(double a, double b) => a > b ? a : b;
