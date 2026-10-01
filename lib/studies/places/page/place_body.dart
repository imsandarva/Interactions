import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';
import 'package:interactions/studies/places/theme/places_style.dart';

/// The words that appear once the card has mostly become the page.
class PlaceBody extends StatelessWidget {
  const PlaceBody({required this.place, super.key});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.textScalerOf(context).scale(1) <= 1.3;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PlacesSpec.padPage,
        22,
        PlacesSpec.padPage,
        8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(place.lead, style: PlacesType.body),
          const SizedBox(height: 28),
          wide ? _DetailRow(place: place) : _DetailStack(place: place),
          const SizedBox(height: 28),
          for (final paragraph in place.more) ...[
            Text(paragraph, style: PlacesType.body),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Pair(caption: 'Best time', value: place.bestTime),
        ),
        const _Hairline(),
        Expanded(
          child: _Pair(caption: 'Suggested stay', value: place.stay),
        ),
        const _Hairline(),
        Expanded(
          child: _Pair(caption: 'Pace', value: place.pace),
        ),
      ],
    );
  }
}

class _DetailStack extends StatelessWidget {
  const _DetailStack({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Pair(caption: 'Best time', value: place.bestTime),
        const SizedBox(height: 16),
        _Pair(caption: 'Suggested stay', value: place.stay),
        const SizedBox(height: 16),
        _Pair(caption: 'Pace', value: place.pace),
      ],
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair({required this.caption, required this.value});

  final String caption;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(caption, style: PlacesType.caption),
        const SizedBox(height: 4),
        Text(value, style: PlacesType.value),
      ],
    );
  }
}

class _Hairline extends StatelessWidget {
  const _Hairline();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: 1,
        height: 36,
        child: ColoredBox(color: PlacesColors.line),
      ),
    );
  }
}
