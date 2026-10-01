import 'dart:ui' show lerpDouble;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/motion/place_flight.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';
import 'package:interactions/studies/places/page/hero_gallery.dart';
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

class _FlightViewState extends State<FlightView>
    with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  var _offset = 0.0;
  late final AnimationController _bar = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );

  PlaceFlight get flight => widget.flight;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _bar.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _onScroll() {
    final next = _scroll.offset;
    if ((next - _offset).abs() > 0.4) setState(() => _offset = next);
    final show = next > flight.heroHeight * 0.62;
    show ? _bar.forward() : _bar.reverse();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _bar.dispose();
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
    final overlap = PlacesSpec.sheetOverlap * (flight.reduced ? 1 : layoutT);
    final panelRadius = 28.0 * (flight.reduced ? 1 : layoutT);
    final tint =
        (flight.reduced ? 1.0 : PlacesSpec.fade(layoutT, 0, 0.7)) *
        PlacesSpec.tintMix;
    final surface = place.tone.surface(
      flight.reduced ? PlacesSpec.tintMix : tint,
    );
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
    final titleTop = lerpDouble(16, 20, layoutT)!;
    final close = flight.reduced
        ? 1.0
        : PlacesSpec.fade(layoutT, PlacesSpec.closeStart, PlacesSpec.closeEnd);
    final wash = PlacesSpec.fade(layoutT, 0.35, 0.85);
    final indicator = flight.reduced ? 1.0 : PlacesSpec.fade(layoutT, 0.92, 1);
    final cardExtra = origin.imageHeight * 0.16;
    final heroExtra = imageHeight * 0.55;
    final extra = lerpDouble(cardExtra, heroExtra, layoutT)!;
    final scrollShift = (_offset * PlacesSpec.parallax).clamp(
      0.0,
      heroExtra / 2,
    );
    final photoShift = flight.reduced
        ? 0.0
        : lerpDouble(origin.photoShift, scrollShift, layoutT)!;
    final viewport = (imageHeight - overlap).clamp(1.0, imageHeight);
    final safe = MediaQuery.paddingOf(context);
    final canScroll = flight.settledOpen && !flight.dragging;
    final bar = _bar.value;
    final light = flight.bounds.top < 28 && flight.layoutT > 0.58 && bar < 0.45;
    final lead = flight.reduced ? 1.0 : PlacesSpec.stagger(layoutT, 0);
    final details = flight.reduced ? 1.0 : PlacesSpec.stagger(layoutT, 1);
    final rest = flight.reduced ? 1.0 : PlacesSpec.stagger(layoutT, 2);
    final page = ColoredBox(
      color: surface,
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
                  child: HeroGallery(
                    place: place,
                    viewport: viewport,
                    photoHeight: imageHeight,
                    shift: photoShift,
                    extra: extra,
                    interactive: flight.settledOpen,
                    reduced: flight.reduced,
                    indicator: indicator,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _Sheet(
                    place: place,
                    surface: surface,
                    radius: panelRadius,
                    pad: pad,
                    titleTop: titleTop,
                    titleSize: titleSize,
                    metaSize: metaSize,
                    titleFocus: widget.titleFocus,
                    lead: lead,
                    details: details,
                    rest: rest,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: safe.bottom + 108)),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: IgnorePointer(
              child: Opacity(
                opacity: wash * (1 - bar),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x381C1A17), Color(0x001C1A17)],
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
              opacity: close * (1 - bar),
              child: IgnorePointer(
                ignoring: close * (1 - bar) < 0.45,
                child: PlaceClose(
                  onPressDown: flight.claim,
                  onPressCancel: flight.unclaimAndResume,
                  onPressed: flight.close,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopBar(
              t: bar,
              title: place.title,
              surface: surface,
              deep: place.tone.deep,
              top: safe.top,
              onClose: flight.close,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: lead < 0.45,
              child: Opacity(
                opacity: lead,
                child: _SaveBar(
                  bottom: safe.bottom,
                  surface: surface,
                  place: place,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return AnimatedBuilder(
      animation: _bar,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: light && _bar.value < 0.45
              ? PlacesStatus.light
              : PlacesStatus.dark,
          child: child!,
        );
      },
      child: Semantics(
        key: const Key('place-page'),
        container: true,
        label: place.title,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(flight.radius),
            boxShadow: flight.shadow < 0.02
                ? null
                : [
                    BoxShadow(
                      color: const Color(
                        0xFF1C1A17,
                      ).withValues(alpha: 0.16 * flight.shadow),
                      blurRadius: 28 * flight.shadow,
                      offset: Offset(0, 18 * flight.shadow),
                    ),
                  ],
          ),
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
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.place,
    required this.surface,
    required this.radius,
    required this.pad,
    required this.titleTop,
    required this.titleSize,
    required this.metaSize,
    required this.titleFocus,
    required this.lead,
    required this.details,
    required this.rest,
  });

  final Place place;
  final Color surface;
  final double radius;
  final double pad;
  final double titleTop;
  final double titleSize;
  final double metaSize;
  final FocusNode titleFocus;
  final double lead;
  final double details;
  final double rest;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(pad, titleTop, pad, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Focus(
              focusNode: titleFocus,
              child: Text(place.title, style: PlacesType.title(titleSize)),
            ),
            const SizedBox(height: 4),
            Text(place.meta, style: PlacesType.metaSized(metaSize)),
            PlaceBody(place: place, lead: lead, details: details, rest: rest),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.t,
    required this.title,
    required this.surface,
    required this.deep,
    required this.top,
    required this.onClose,
  });

  final double t;
  final String title;
  final Color surface;
  final Color deep;
  final double top;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final shown = t.clamp(0.0, 1.0);
    return IgnorePointer(
      ignoring: shown < 0.4,
      child: Opacity(
        opacity: shown,
        child: Transform.translate(
          offset: Offset(0, -10 * (1 - shown)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: surface,
              border: const Border(
                bottom: BorderSide(color: PlacesColors.line),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, top, 8, 0),
              child: SizedBox(
                height: 56,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: PlacesType.title(16),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onClose,
                      child: Semantics(
                        button: true,
                        label: 'Close',
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: deep.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const SizedBox(
                                width: 32,
                                height: 32,
                                child: CustomPaint(painter: _BarMark()),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarMark extends CustomPainter {
  const _BarMark();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PlacesColors.ink
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const inset = 11.0;
    canvas.drawLine(
      const Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(_BarMark oldDelegate) => false;
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.bottom,
    required this.surface,
    required this.place,
  });

  final double bottom;
  final Color surface;
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IgnorePointer(
          child: SizedBox(
            height: 28,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [surface.withValues(alpha: 0), surface],
                ),
              ),
            ),
          ),
        ),
        ColoredBox(
          color: surface,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              PlacesSpec.gutter,
              0,
              PlacesSpec.gutter,
              bottom + 12,
            ),
            child: PlaceSave(place: place, surface: surface),
          ),
        ),
      ],
    );
  }
}
