import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:interactions/app/system/system_chrome.dart';
import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/motion/place_flight.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';
import 'package:interactions/studies/places/stage/places_stage.dart';

/// Study 03. A place card and its page are the same object.
class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final PlaceFlight _flight = PlaceFlight(vsync: this);
  final _hidden = ValueNotifier<int?>(null);
  final _stackKey = GlobalKey();
  final _scroll = ScrollController();
  final _titleFocus = FocusNode(debugLabel: 'place-title');
  final _frameKeys = List<GlobalKey>.generate(
    Places.all.length,
    (_) => GlobalKey(),
  );
  final _imageKeys = List<GlobalKey>.generate(
    Places.all.length,
    (_) => GlobalKey(),
  );
  final _cardFocus = List<FocusNode>.generate(
    Places.all.length,
    (index) => FocusNode(debugLabel: 'place-$index'),
  );
  var _wasActive = false;
  var _focused = false;
  var _warmed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _flight.addListener(_onFlight);
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _flight.setReduced(MediaQuery.disableAnimationsOf(context));
    _flight.adopt(MediaQuery.sizeOf(context));
    if (_warmed) return;
    _warmed = true;
    for (final place in Places.all) {
      final photo = place.photo;
      if (photo != null) precacheImage(AssetImage(photo), context);
    }
  }

  void _onFlight() {
    final hide = _flight.active && !_flight.reduced ? _flight.index : null;
    if (_hidden.value != hide) _hidden.value = hide;
    if (_flight.settledOpen && !_focused) {
      _focused = true;
      _focus(_titleFocus);
    }
    if (!_flight.active && _wasActive) {
      _focused = false;
      final index = _flight.index;
      if (index != null) _focus(_cardFocus[index]);
    }
    _wasActive = _flight.active;
  }

  void _focus(FocusNode node) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) node.requestFocus();
    });
  }

  void _open(int index) {
    if (_flight.active) return;
    if (_scroll.hasClients) _scroll.jumpTo(_scroll.offset);
    final rect = _rectFor(_frameKeys[index]);
    final image = _heightOf(_imageKeys[index]);
    if (rect == null || image == null) return;
    _flight.open(
      PlaceOrigin(index: index, rect: rect, imageHeight: image),
      _stackSize(),
    );
  }

  Rect? _rectFor(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final stack = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || stack == null || !box.hasSize || !box.attached) {
      return null;
    }
    return box.localToGlobal(Offset.zero, ancestor: stack) & box.size;
  }

  double? _heightOf(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.size.height;
  }

  Size _stackSize() {
    final box = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) return box.size;
    return MediaQuery.sizeOf(context);
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent event) {
    if (event.isButtonEvent || !_flight.active || !_routeCurrent) return false;
    _scrub(event);
    return true;
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent event) =>
      _scrub(event);

  @override
  void handleCommitBackGesture() => _flight.endEdge(commit: true, speed: 1.8);

  @override
  void handleCancelBackGesture() => _flight.endEdge(commit: false, speed: 1.2);

  bool get _routeCurrent {
    final route = ModalRoute.of(context);
    return route == null || route.isCurrent;
  }

  void _scrub(PredictiveBackEvent event) {
    final dir = event.swipeEdge == SwipeEdge.right ? -1.0 : 1.0;
    final shift =
        event.progress * _flight.screen.width * PlacesSpec.edgeShift * dir;
    _flight.edgeTo(event.progress, shift);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flight.removeListener(_onFlight);
    _flight.dispose();
    _hidden.dispose();
    _scroll.dispose();
    _titleFocus.dispose();
    for (final node in _cardFocus) {
      node.dispose();
    }
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    applySystemChrome();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlacesStage(
      flight: _flight,
      hidden: _hidden,
      stackKey: _stackKey,
      scroll: _scroll,
      frameKeys: _frameKeys,
      imageKeys: _imageKeys,
      focusNodes: _cardFocus,
      titleFocus: _titleFocus,
      onOpen: _open,
    );
  }
}
