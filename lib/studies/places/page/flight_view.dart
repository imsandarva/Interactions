import 'dart:ui' show lerpDouble;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/image/place_image.dart';
import 'package:interactions/studies/places/motion/place_flight.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';
import 'package:interactions/studies/places/page/page_drag.dart';
import 'package:interactions/studies/places/page/place_body.dart';
import 'package:interactions/studies/places/page/place_close.dart';
import 'package:interactions/studies/places/page/place_save.dart';
import 'package:interactions/studies/places/theme/places_style.dart';

/// The card and the page, drawn as one surface.
class FlightView extends StatefulWidget {
  const FlightView({required this.flight, required this.titleFocus, super.key});

  final PlaceFlight flight;
  final FocusNode titleFocus;

  @override
  State<FlightView> createState() => _FlightViewState();
}

class _FlightViewState extends State<FlightView> {
  final _scroll = ScrollController();
  var _offset = 0.0;

  PlaceFlight get flight => widget.flight;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final next = _scroll.offset;
    if ((next - _offset).abs() < 0.4) return;
    setState(() => _offset = next);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final origin = flight.origin;
    final place = origin == null ? null : Places.all[origin.index];
    if (place == null || origin == null) return const SizedBox.shrink();
    final layoutT = flight.reduced ? 1.0 : flight.layoutT;
    final imageHeight = lerpDouble(
      origin.imageHeight,
      flight.heroHeight,
      layoutT,
    )!;
    final titleSize = lerpDouble(
      PlacesSpec.titleCard,
      PlacesSpec.titlePage,
      layoutT,
    )!;
    final metaSize = lerpDouble(
      PlacesSpec.metaCard,
      PlacesSpec.metaPage,
      layoutT,
    )!;
    final pad = lerpDouble(PlacesSpec.padCard, PlacesSpec.padPage, layoutT)!;
    final body = flight.reduced
        ? 1.0
        : PlacesSpec.fade(layoutT, PlacesSpec.bodyStart, PlacesSpec.bodyEnd);
    final close = flight.reduced
        ? 1.0
        : PlacesSpec.fade(layoutT, PlacesSpec.closeStart, PlacesSpec.closeEnd);
    final wash = PlacesSpec.fade(layoutT, 0.35, 0.85);
    final extra = imageHeight * 0.5;
    final parallax = flight.reduced
        ? 0.0
        : (_offset * PlacesSpec.parallax).clamp(0.0, extra);
    final safe = MediaQuery.paddingOf(context);
    final canScroll = flight.settledOpen && !flight.dragging;
    final light =
        flight.bounds.top < 28 && flight.layoutT > 0.58 && _offset < 40;
    final page = ColoredBox(
      color: PlacesColors.surface,
      child: Stack(
        children: [
          PageDrag(
            flight: flight,
            scroll: _scroll,
            child: CustomScrollView(
              controller: _scroll,
              primary: false,
              physics: canScroll
                  ? const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    )
                  : const NeverScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _Hero(
                    place: place,
                    height: imageHeight,
                    extra: extra,
                    shift: parallax,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      pad,
                      lerpDouble(16, 18, layoutT)!,
                      pad,
                      0,
                    ),
                    child: Focus(
                      focusNode: widget.titleFocus,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place.title, style: PlacesType.title(titleSize)),
                          const SizedBox(height: 4),
                          Text(
                            place.meta,
                            style: PlacesType.metaSized(metaSize),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Opacity(
                    opacity: body,
                    child: Transform.translate(
                      offset: Offset(0, (1 - body) * PlacesSpec.bodyRise),
                      child: PlaceBody(place: place),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: safe.bottom + 96)),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 108,
            child: IgnorePointer(
              child: Opacity(
                opacity: wash,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x471C1A17), Color(0x001C1A17)],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: safe.top + 6,
            right: 10,
            child: Opacity(
              opacity: close,
              child: IgnorePointer(
                ignoring: close < 0.45,
                child: PlaceClose(
                  onPressDown: flight.claim,
                  onPressCancel: flight.unclaimAndResume,
                  onPressed: flight.close,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: body < 0.45,
              child: Opacity(
                opacity: body,
                child: _SaveBar(bottom: safe.bottom),
              ),
            ),
          ),
        ],
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: light ? PlacesStatus.light : PlacesStatus.dark,
      child: Semantics(
        key: const Key('place-page'),
        container: true,
        label: place.title,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(flight.radius),
          child: Opacity(
            opacity: flight.reduced ? flight.layoutT.clamp(0.0, 1.0) : 1,
            child: Transform.translate(
              offset: Offset(0, flight.reduced ? flight.shiftY : 0),
              child: page,
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.place,
    required this.height,
    required this.extra,
    required this.shift,
  });

  final Place place;
  final double height;
  final double extra;
  final double shift;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return ClipRect(
          child: SizedBox(
            height: height,
            width: width,
            child: Transform.translate(
              offset: Offset(0, -shift),
              child: OverflowBox(
                alignment: Alignment.topCenter,
                minWidth: width,
                maxWidth: width,
                minHeight: height + extra,
                maxHeight: height + extra,
                child: PlaceImage(place: place),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.bottom});

  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const IgnorePointer(
          child: SizedBox(
            height: 28,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00FFFCF8), PlacesColors.surface],
                ),
              ),
            ),
          ),
        ),
        ColoredBox(
          color: PlacesColors.surface,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              PlacesSpec.gutter,
              0,
              PlacesSpec.gutter,
              bottom + 12,
            ),
            child: const PlaceSave(),
          ),
        ),
      ],
    );
  }
}
