import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:interactions/studies/places/list/places_feed.dart';
import 'package:interactions/studies/places/motion/place_flight.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';
import 'package:interactions/studies/places/page/edge_scrub.dart';
import 'package:interactions/studies/places/page/flight_view.dart';
import 'package:interactions/studies/places/theme/places_style.dart';

/// The list, the dim layer behind it, and the card that is leaving the list.
class PlacesStage extends StatelessWidget {
  const PlacesStage({
    required this.flight,
    required this.hidden,
    required this.stackKey,
    required this.scroll,
    required this.frameKeys,
    required this.imageKeys,
    required this.focusNodes,
    required this.titleFocus,
    required this.onOpen,
    super.key,
  });

  final PlaceFlight flight;
  final ValueNotifier<int?> hidden;
  final GlobalKey stackKey;
  final ScrollController scroll;
  final List<GlobalKey> frameKeys;
  final List<GlobalKey> imageKeys;
  final List<FocusNode> focusNodes;
  final FocusNode titleFocus;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final android = Theme.of(context).platform == TargetPlatform.android;
    return ListenableBuilder(
      listenable: flight,
      builder: (context, feed) {
        final bounds = flight.bounds;
        return PopScope(
          canPop: !flight.active,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) flight.close();
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: PlacesStatus.dark,
            child: Scaffold(
              backgroundColor: PlacesColors.paper,
              body: Stack(
                key: stackKey,
                clipBehavior: Clip.hardEdge,
                children: [
                  IgnorePointer(
                    ignoring: flight.active,
                    child: Transform.scale(
                      scale: flight.listScale,
                      filterQuality: FilterQuality.medium,
                      child: feed,
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: PlacesColors.scrim.withValues(
                          alpha: flight.scrimAlpha,
                        ),
                      ),
                    ),
                  ),
                  if (flight.active)
                    Positioned(
                      left: bounds.left,
                      top: bounds.top,
                      width: bounds.width,
                      height: bounds.height,
                      child: FlightView(
                        key: ValueKey(flight.generation),
                        flight: flight,
                        titleFocus: titleFocus,
                      ),
                    ),
                  if (flight.active && !android)
                    Positioned(
                      left: rtl ? null : 0,
                      right: rtl ? 0 : null,
                      top: 0,
                      bottom: 0,
                      width: PlacesSpec.edgeWidth,
                      child: EdgeScrub(flight: flight),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      child: PlacesFeed(
        scroll: scroll,
        hidden: hidden,
        frameKeys: frameKeys,
        imageKeys: imageKeys,
        focusNodes: focusNodes,
        onOpen: onOpen,
      ),
    );
  }
}
