import 'package:flutter/widgets.dart';

/// One place. [photo] is optional; until a real file is set, the tone is painted.
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
    this.photo,
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

  /// Asset path, declared in pubspec, when a photograph replaces the tone.
  final String? photo;

  String get meta => '$country · $detail';
  String get label => '$title, $meta';
}

class PlaceTone {
  const PlaceTone({
    required this.base,
    required this.glow,
    required this.shade,
    required this.focal,
    required this.seed,
  });

  final Color base;
  final Color glow;
  final Color shade;
  final Alignment focal;
  final int seed;
}

/// Dummy places. Swap the words if you like; keep them short and quiet.
abstract final class Places {
  static const all = <Place>[
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
      tone: PlaceTone(
        base: Color(0xFF6B5348),
        glow: Color(0xFFE4C7B0),
        shade: Color(0xFF3E322C),
        focal: Alignment(0, -0.35),
        seed: 11,
      ),
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
      pace: 'Unhurried',
      tone: PlaceTone(
        base: Color(0xFFE6D3B8),
        glow: Color(0xFFF7F1E6),
        shade: Color(0xFFC5D0D4),
        focal: Alignment(0, -0.15),
        seed: 23,
      ),
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
      pace: 'Still',
      tone: PlaceTone(
        base: Color(0xFF8FA3A6),
        glow: Color(0xFFD5E0E2),
        shade: Color(0xFF3E5156),
        focal: Alignment(0.1, -0.4),
        seed: 37,
      ),
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
      pace: 'Gentle',
      tone: PlaceTone(
        base: Color(0xFF8A9A78),
        glow: Color(0xFFD7E0C8),
        shade: Color(0xFF3E4A38),
        focal: Alignment(0, 0.05),
        seed: 41,
      ),
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
      bestTime: 'March to June',
      stay: '4 nights',
      pace: 'Wandering',
      tone: PlaceTone(
        base: Color(0xFFC9A08C),
        glow: Color(0xFFF0D9CC),
        shade: Color(0xFF8C6558),
        focal: Alignment(-0.2, -0.45),
        seed: 53,
      ),
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
      bestTime: 'September',
      stay: '3 nights',
      pace: 'Steady',
      tone: PlaceTone(
        base: Color(0xFF9AA0A4),
        glow: Color(0xFFE4E0D8),
        shade: Color(0xFF5C6368),
        focal: Alignment(0.15, -0.55),
        seed: 67,
      ),
    ),
  ];
}
