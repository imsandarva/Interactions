import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:interactions/studies/payment/motion/pay_frame.dart';
import 'package:interactions/studies/payment/theme/pay_style.dart';

/// Everything visual, derived from one progress value so a drag can scrub it.
class MorphScene {
  const MorphScene({
    required this.t,
    required this.marginH,
    required this.marginBottom,
    required this.height,
    required this.topRadius,
    required this.bottomRadius,
    required this.surface,
    required this.borderAlpha,
    required this.label,
    required this.backdropScale,
    required this.backdropDim,
    required this.backdropRadius,
    required this.openHeight,
  });

  final double t;
  final double marginH;
  final double marginBottom;
  final double height;
  final double topRadius;
  final double bottomRadius;
  final Color surface;
  final double borderAlpha;
  final double label;
  final double backdropScale;
  final double backdropDim;
  final double backdropRadius;
  final double openHeight;

  BorderRadius get radius => BorderRadius.vertical(
    top: Radius.circular(topRadius),
    bottom: Radius.circular(bottomRadius),
  );

  static MorphScene morph(double t, FrameMetrics frame) {
    // Until [_asButton], width, bottom edge, and corners stay the button's,
    // so the stretch reads as that pill growing. Color does not wait: it
    // eases across the entire gesture, dark at the pill and paper at the
    // sheet, and the collapse walks the same blend backward.
    final become = _span(t, _asButton, 0.92);
    final height = _height(t, frame.openHeight);
    final cap = height / 2;
    final mix = t;
    final backdrop = _unit(t, _asButton, 1);
    return MorphScene(
      t: t,
      marginH: _lerp(frame.side, 0, become),
      marginBottom: _lerp(frame.restBottom, 0, become),
      height: height,
      topRadius: math.min(_lerp(PayFrame.pillRadius, PayFrame.sheetRadius, become), cap),
      bottomRadius: math.min(_lerp(PayFrame.pillRadius, 0, _span(t, _asButton, 0.84)), cap),
      surface: Color.lerp(PayColors.ink, PayColors.sheet, mix)!,
      borderAlpha: mix,
      label: t >= 0.14 ? 0 : 1 - Curves.easeOut.transform(t / 0.14),
      backdropScale: _lerp(1, PayFrame.backdropScale, backdrop),
      backdropDim: 0.16 * backdrop,
      backdropRadius: _lerp(0, 18, backdrop),
      openHeight: frame.openHeight,
    );
  }
}

/// Progress at which the stretching pill is allowed to become the sheet.
const _asButton = 0.5;

double _height(double t, double sheet) {
  const pill = PayFrame.pillHeight;
  // Most of the travel, still wearing the button, so the stretch is obvious.
  final tall = pill + (sheet - pill) * 0.58;
  if (t <= _asButton) return _lerp(pill, tall, t / _asButton);
  return _lerp(tall, sheet, (t - _asButton) / (1 - _asButton));
}

double _lerp(double a, double b, double t) => a + (b - a) * t;

/// Linear 0 before [a], 1 after [b]. The spring already eases the clock.
double _span(double t, double a, double b) {
  if (t <= a) return 0;
  if (t >= b) return 1;
  return (t - a) / (b - a);
}

/// 0 before [a], 1 after [b], eased in between.
double _unit(double t, double a, double b) {
  if (t <= a) return 0;
  if (t >= b) return 1;
  return Curves.easeOutCubic.transform((t - a) / (b - a));
}

/// Where each group fades in along the same progress value.
abstract final class PayReveal {
  static double header(double t) => _unit(t, 0.64, 0.80);
  static double benefits(double t) => _unit(t, 0.70, 0.86);
  static double plans(double t) => _unit(t, 0.76, 0.90);
  static double trust(double t) => _unit(t, 0.80, 0.94);
  static double cta(double t) => _unit(t, 0.86, 0.98);
  static double close(double t) => _unit(t, 0.92, 1);
}
