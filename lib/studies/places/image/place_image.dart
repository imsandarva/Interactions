import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/image/place_field.dart';

/// The same picture on the card and on the page, so the flight never swaps it.
class PlaceImage extends StatelessWidget {
  const PlaceImage({required this.place, super.key});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final photo = place.photo;
    if (photo == null) return PlaceField(tone: place.tone);
    return Image.asset(
      photo,
      fit: BoxFit.cover,
      alignment: place.tone.focal,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
