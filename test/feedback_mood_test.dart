import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:interactions/studies/feedback/face/face_pose.dart';
import 'package:interactions/studies/feedback/mood/mood.dart';
import 'package:interactions/studies/feedback/theme/mood_palette.dart';

void main() {
  test('resting poses are pure and the midpoint is half', () {
    expect(FacePose.compose(0).tilt, closeTo(FacePose.bad.tilt, 0.0001));
    expect(FacePose.compose(0).mouthCurve, closeTo(FacePose.bad.mouthCurve, 0.0001));
    expect(FacePose.compose(0.5).eyeH, closeTo(FacePose.fine.eyeH, 0.0001));
    expect(FacePose.compose(0.5).mouthW, closeTo(FacePose.fine.mouthW, 0.0001));
    expect(FacePose.compose(1).eyeW, closeTo(FacePose.great.eyeW, 0.0001));
    expect(FacePose.compose(1).mouthCurve, closeTo(FacePose.great.mouthCurve, 0.0001));

    final mid = FacePose.compose(0.75);
    final halfEyes = (FacePose.fine.eyeH + FacePose.great.eyeH) / 2;
    expect(mid.eyeH, closeTo(halfEyes, 0.001));
    expect(mid.eyeW, closeTo((FacePose.fine.eyeW + FacePose.great.eyeW) / 2, 0.001));
  });

  test('the word changes at a quarter and three quarters', () {
    expect(moodAt(0), Mood.bad);
    expect(moodAt(0.24), Mood.bad);
    expect(moodAt(0.25), Mood.fine);
    expect(moodAt(0.74), Mood.fine);
    expect(moodAt(0.75), Mood.great);
    expect(moodAt(1), Mood.great);
    expect(nearestMood(0.1).anchor, 0);
    expect(nearestMood(0.6).anchor, 0.5);
    expect(nearestMood(0.8).anchor, 1);
  });

  test('mood color stays light, readable, and routed through butter', () {
    expect(_near(MoodPalette.at(0).surface, MoodPalette.badSurface), isTrue);
    expect(_near(MoodPalette.at(0.5).surface, MoodPalette.fineSurface), isTrue);
    expect(_near(MoodPalette.at(1).surface, MoodPalette.greatSurface), isTrue);

    for (var i = 0; i <= 20; i++) {
      final tone = MoodPalette.at(i / 20);
      final hsl = HSLColor.fromColor(tone.surface);
      expect(hsl.lightness, greaterThan(0.78), reason: 'surface at ${i / 20}');
      expect(hsl.saturation, greaterThan(0.28), reason: 'surface at ${i / 20}');
      expect(_contrast(tone.deep, tone.surface), greaterThanOrEqualTo(4.5), reason: 'text at ${i / 20}');
    }
  });
}

bool _near(Color a, Color b) {
  return (a.r - b.r).abs() < 0.02 && (a.g - b.g).abs() < 0.02 && (a.b - b.b).abs() < 0.02;
}

double _contrast(Color a, Color b) {
  final hi = math.max(_lum(a), _lum(b));
  final lo = math.min(_lum(a), _lum(b));
  return (hi + 0.05) / (lo + 0.05);
}

double _lum(Color c) => 0.2126 * _lin(c.r) + 0.7152 * _lin(c.g) + 0.0722 * _lin(c.b);

double _lin(double c) => c <= 0.04045 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
