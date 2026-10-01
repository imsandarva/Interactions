import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/list/place_card.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';
import 'package:interactions/studies/places/theme/places_style.dart';

/// The quiet list. Cards arrive once, then the header scrolls away with them.
class PlacesFeed extends StatefulWidget {
  const PlacesFeed({
    required this.scroll,
    required this.offset,
    required this.hidden,
    required this.frameKeys,
    required this.imageKeys,
    required this.focusNodes,
    required this.onOpen,
    super.key,
  });

  final ScrollController scroll;
  final ValueNotifier<double> offset;
  final ValueNotifier<int?> hidden;
  final List<GlobalKey> frameKeys;
  final List<GlobalKey> imageKeys;
  final List<FocusNode> focusNodes;
  final void Function(int index, double photoShift) onOpen;

  static const rise = 450.0;
  static const gap = 60.0;

  @override
  State<PlacesFeed> createState() => _PlacesFeedState();
}

class _PlacesFeedState extends State<PlacesFeed>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: (PlacesFeed.rise + PlacesFeed.gap * 5).round(),
    ),
  );
  var _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _intro.value = 1;
    } else {
      _intro.forward();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  double _span(double t, int index, double length) {
    final total = PlacesFeed.rise + PlacesFeed.gap * 5;
    final start = index * PlacesFeed.gap / total;
    final end = (index * PlacesFeed.gap + length) / total;
    if (t <= start) return 0;
    if (t >= end) return 1;
    final u = (t - start) / (end - start);
    return u * u * (3 - 2 * u);
  }

  @override
  Widget build(BuildContext context) {
    final safe = MediaQuery.paddingOf(context);
    final places = Places.all;
    return AnimatedBuilder(
      animation: _intro,
      builder: (context, _) {
        final t = _intro.value;
        return CustomScrollView(
          controller: widget.scroll,
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
                12,
              ),
              sliver: SliverList.separated(
                itemCount: places.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: PlacesSpec.gap),
                itemBuilder: (context, index) {
                  return PlaceCard(
                    place: places[index],
                    frameKey: widget.frameKeys[index],
                    imageKey: widget.imageKeys[index],
                    focusNode: widget.focusNodes[index],
                    hidden: widget.hidden,
                    scroll: widget.offset,
                    appear: _span(t, index, PlacesFeed.rise),
                    photoAppear: _span(t, index, 300),
                    onOpen: (shift) => widget.onOpen(index, shift),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                PlacesSpec.gutter,
                8,
                PlacesSpec.gutter,
                safe.bottom + 28,
              ),
              sliver: const SliverToBoxAdapter(child: _Credits()),
            ),
          ],
        );
      },
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

class _Credits extends StatelessWidget {
  const _Credits();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Photographs by Thomas Bormans, pgab, Andrea Huls Pareja, Matheus Oliveira, Silas Baisch, and others on Unsplash.',
      style: PlacesType.caption,
    );
  }
}
