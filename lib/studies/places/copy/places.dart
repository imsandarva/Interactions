import 'package:flutter/widgets.dart';

/// A muted color taken from the cover, and the deeper version used for the button.
class PlaceTone {
  const PlaceTone({required this.tone, required this.deep});

  final Color tone;
  final Color deep;

  /// Warm white with a few percent of [tone]. Felt, not seen.
  Color surface(double amount) =>
      Color.lerp(const Color(0xFFFFFCF8), tone, amount)!;
}

class PlacePhoto {
  const PlacePhoto({
    required this.asset,
    required this.focal,
    required this.credit,
  });

  final String asset;
  final Alignment focal;
  final String credit;
}

/// One place. The first photograph is the cover, until the list remembers another.
class Place {
  const Place({
    required this.id,
    required this.title,
    required this.country,
    required this.detail,
    required this.lead,
    required this.more,
    required this.bestTime,
    required this.stay,
    required this.pace,
    required this.tone,
    required this.photos,
  });

  final int id;
  final String title;
  final String country;
  final String detail;
  final String lead;
  final List<String> more;
  final String bestTime;
  final String stay;
  final String pace;
  final PlaceTone tone;
  final List<PlacePhoto> photos;

  String get meta => '$country · $detail';
  String get label => '$title, $meta';

  PlacePhoto photoAt(int index) => photos[index.clamp(0, photos.length - 1)];
}

const _high = Alignment(0, -0.35);
const _soft = Alignment(0, -0.08);

PlacePhoto _shot(String name, Alignment focal, String credit) {
  return PlacePhoto(
    asset: 'assets/places/$name.jpg',
    focal: focal,
    credit: credit,
  );
}

/// Dummy places. The words stay quiet; the photographs are real.
abstract final class Places {
  static final all = <Place>[
    Place(
      id: 0,
      title: 'Quiet Hours in Kyoto',
      country: 'Japan',
      detail: 'Temples & tea',
      lead:
          'Morning arrives before the city does. Steam lifts off the tea, and the temple path stays empty a little longer.',
      more: [
        'You walk without a plan. A side street, a paper screen left open, the sound of a broom on stone.',
        'Nothing needs deciding until the light has warmed the wood.',
      ],
      bestTime: 'March to May',
      stay: '3 nights',
      pace: 'Slow',
      tone: const PlaceTone(tone: Color(0xFF7A8470), deep: Color(0xFF3E4637)),
      photos: [
        _shot('kyoto_1', _high, 'Unsplash'),
        _shot('kyoto_2', _soft, 'Thomas Bormans, Unsplash'),
        _shot('kyoto_3', _high, 'Unsplash'),
      ],
    ),
    Place(
      id: 1,
      title: 'Salt Flats at Dawn',
      country: 'Bolivia',
      detail: 'Open sky',
      lead:
          'The ground and the sky trade places before sunrise. Salt holds the last of the night, then lets it go.',
      more: [
        'Nothing asks you to hurry. The horizon is the whole view, and it stays that way.',
        'By late morning the white has gone hard and bright, and the day is already simple.',
      ],
      bestTime: 'May to October',
      stay: '2 nights',
      pace: 'Slow',
      tone: const PlaceTone(tone: Color(0xFF8FA3B0), deep: Color(0xFF3B4C58)),
      photos: [
        _shot('salt_1', _high, 'pgab, Unsplash'),
        _shot('salt_2', _high, 'Andrea Huls Pareja, Unsplash'),
        _shot('salt_3', _high, 'Matheus Oliveira, Unsplash'),
      ],
    ),
    Place(
      id: 2,
      title: 'A Cabin by the Fjord',
      country: 'Norway',
      detail: 'Stillness',
      lead:
          'The water does not move, and neither do you. Wood, wool, and a window full of gray-green light.',
      more: [
        'Rain comes in quietly. The stove answers. Outside, the fjord keeps its own hours.',
        'There is a path along the shore, and no reason to take it until you want to.',
      ],
      bestTime: 'June to August',
      stay: '4 nights',
      pace: 'Very slow',
      tone: const PlaceTone(tone: Color(0xFF5C7384), deep: Color(0xFF26394A)),
      photos: [
        _shot('fjord_1', _soft, 'Unsplash'),
        _shot('fjord_2', _high, 'Unsplash'),
        _shot('fjord_3', _high, 'Unsplash'),
      ],
    ),
    Place(
      id: 3,
      title: 'Rice Terraces, Slow Season',
      country: 'Indonesia',
      detail: 'Green steps',
      lead:
          'The hills are cut into steps of green, one after another, all the way down to the river.',
      more: [
        'Planting is finished. The water sits in the paddies and the afternoons stretch.',
        'Someone is always working a row you cannot quite see, and the valley stays hushed.',
      ],
      bestTime: 'April to June',
      stay: '3 nights',
      pace: 'Easy',
      tone: const PlaceTone(tone: Color(0xFF7C9A5E), deep: Color(0xFF34502A)),
      photos: [
        _shot('rice_2', Alignment(0, 0.05), 'Unsplash'),
        _shot('rice_1', _high, 'Silas Baisch, Unsplash'),
        _shot('rice_3', _soft, 'Unsplash'),
      ],
    ),
    Place(
      id: 4,
      title: 'Lisbon in Soft Light',
      country: 'Portugal',
      detail: 'Tiled streets',
      lead:
          'The light here is low and kind, even at noon. Tile, laundry, and a tram somewhere below.',
      more: [
        'You climb until the wind finds you. Then a small table, and the river in the distance.',
        'The hills do the pacing. You only have to follow them down again.',
      ],
      bestTime: 'September to November',
      stay: '4 nights',
      pace: 'Easy',
      tone: const PlaceTone(tone: Color(0xFFC98F6B), deep: Color(0xFF6B3E25)),
      photos: [
        _shot('lisbon_1', _soft, 'Unsplash'),
        _shot('lisbon_2', _high, 'Unsplash'),
        _shot('lisbon_3', _soft, 'Unsplash'),
      ],
    ),
    Place(
      id: 5,
      title: 'Dolomites, Early Autumn',
      country: 'Italy',
      detail: 'High trails',
      lead:
          'The rock turns warm just before the sun drops. Trails are quiet, and the air is already thin.',
      more: [
        'A hut, a bowl of soup, and the long walk back down through the trees.',
        'The peaks stay lit a little after the valley has gone blue.',
      ],
      bestTime: 'September to October',
      stay: '5 nights',
      pace: 'Active',
      tone: const PlaceTone(tone: Color(0xFFA08C8F), deep: Color(0xFF4F3F46)),
      photos: [
        _shot('alps_1', _soft, 'Unsplash'),
        _shot('alps_2', _high, 'Unsplash'),
        _shot('alps_3', _high, 'Unsplash'),
      ],
    ),
  ];

  static String get credits {
    final names = <String>{};
    for (final place in all) {
      for (final photo in place.photos) {
        names.add(photo.credit);
      }
    }
    return 'Photographs from Unsplash.';
  }
}
