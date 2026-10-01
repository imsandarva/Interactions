import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/list/place_card.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';
import 'package:interactions/studies/places/theme/places_style.dart';

/// The quiet list. It scrolls away with its header, and stays put while a page is open.
class PlacesFeed extends StatelessWidget {
  const PlacesFeed({
    required this.scroll,
    required this.hidden,
    required this.frameKeys,
    required this.imageKeys,
    required this.focusNodes,
    required this.onOpen,
    super.key,
  });

  final ScrollController scroll;
  final ValueNotifier<int?> hidden;
  final List<GlobalKey> frameKeys;
  final List<GlobalKey> imageKeys;
  final List<FocusNode> focusNodes;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final safe = MediaQuery.paddingOf(context);
    final places = Places.all;
    return CustomScrollView(
      controller: scroll,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            PlacesSpec.gutter,
            safe.top + 12,
            PlacesSpec.gutter,
            0,
          ),
          sliver: const SliverToBoxAdapter(child: _Header()),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            PlacesSpec.gutter,
            22,
            PlacesSpec.gutter,
            safe.bottom + 28,
          ),
          sliver: SliverList.separated(
            itemCount: places.length,
            separatorBuilder: (_, _) => const SizedBox(height: PlacesSpec.gap),
            itemBuilder: (context, index) {
              return PlaceCard(
                place: places[index],
                frameKey: frameKeys[index],
                imageKey: imageKeys[index],
                focusNode: focusNodes[index],
                hidden: hidden,
                onOpen: () => onOpen(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Places', style: PlacesType.header),
        SizedBox(height: 6),
        Text('Quiet corners worth the trip', style: PlacesType.headerNote),
      ],
    );
  }
}
