import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// Soft washes that travel Bad → Fine → Great through butter, never through brown.
class MoodPalette {
  const MoodPalette({required this.surface, required this.deep});

  final Color surface;
  final Color deep;

  static const badSurface = Color(0xFFF4CFC6);
  static const badDeep = Color(0xFF5A2A25);
  static const fineSurface = Color(0xFFF4E7B8);
  static const fineDeep = Color(0xFF4A3F1A);
  static const greatSurface = Color(0xFFE3EBD3);
  static const greatDeep = Color(0xFF2E3F26);

  static MoodPalette at(double t) {
    final x = t.clamp(0.0, 1.0);
    if (x <= 0.5) {
      final u = x / 0.5;
      return MoodPalette(surface: _oklab(badSurface, fineSurface, u), deep: _oklab(badDeep, fineDeep, u));
    }
    final u = (x - 0.5) / 0.5;
    return MoodPalette(surface: _oklab(fineSurface, greatSurface, u), deep: _oklab(fineDeep, greatDeep, u));
  }

  Color mix(double amount) => Color.alphaBlend(deep.withValues(alpha: amount), surface);

  Color get track => mix(0.16);
  Color get dot => mix(0.55);
  Color get caption => mix(0.62);
  Color get closeFill => mix(0.12);
  Color get inactiveFill => mix(0.22);
  Color get inactiveLabel => mix(0.48);
  Color get grabber => mix(0.34);
}

Color _oklab(Color a, Color b, double t) {
  final from = _toLab(a);
  final to = _toLab(b);
  return _fromLab(
    from.$1 + (to.$1 - from.$1) * t,
    from.$2 + (to.$2 - from.$2) * t,
    from.$3 + (to.$3 - from.$3) * t,
  );
}

(double, double, double) _toLab(Color c) {
  final r = _linear(c.r);
  final g = _linear(c.g);
  final b = _linear(c.b);
  final l = _cbrt(0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b);
  final m = _cbrt(0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b);
  final s = _cbrt(0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b);
  return (
    0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
    1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
    0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s,
  );
}

Color _fromLab(double l, double a, double b) {
  final l_ = _cube(l + 0.3963377774 * a + 0.2158037573 * b);
  final m_ = _cube(l - 0.1055613458 * a - 0.0638541728 * b);
  final s_ = _cube(l - 0.0894841775 * a - 1.2914855480 * b);
  final r = 4.0767416621 * l_ - 3.3077115913 * m_ + 0.2309699292 * s_;
  final g = -1.2684380046 * l_ + 2.6097574011 * m_ - 0.3413193965 * s_;
  final bl = -0.0041960863 * l_ - 0.7034186147 * m_ + 1.7076147010 * s_;
  return Color.from(
    alpha: 1,
    red: _srgb(r).clamp(0.0, 1.0),
    green: _srgb(g).clamp(0.0, 1.0),
    blue: _srgb(bl).clamp(0.0, 1.0),
  );
}

double _linear(double c) => c <= 0.04045 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();

double _srgb(double c) {
  final x = c.clamp(0.0, 1.0);
  return x <= 0.0031308 ? 12.92 * x : 1.055 * math.pow(x, 1 / 2.4).toDouble() - 0.055;
}

double _cbrt(double x) => x < 0 ? -math.pow(-x, 1 / 3).toDouble() : math.pow(x, 1 / 3).toDouble();

double _cube(double x) => x * x * x;
