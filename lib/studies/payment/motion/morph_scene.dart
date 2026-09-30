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
    // Width, height, and color share one progress. Each is a fraction of its
    // own travel, so they start together and arrive together. Collapse is the
    // same line, played backward.
    final height = _lerp(PayFrame.pillHeight, frame.openHeight, t);
    final cap = height / 2;
    return MorphScene(
      t: t,
      marginH: _lerp(frame.side, 0, t),
      marginBottom: _lerp(frame.restBottom, 0, t),
      height: height,
      topRadius: math.min(_lerp(PayFrame.pillRadius, PayFrame.sheetRadius, t), cap),
      bottomRadius: math.min(_lerp(PayFrame.pillRadius, 0, t), cap),
      surface: Color.lerp(PayColors.ink, PayColors.sheet, t)!,
      borderAlpha: t,
      label: t >= 0.14 ? 0 : 1 - Curves.easeOut.transform(t / 0.14),
      backdropScale: _lerp(1, PayFrame.backdropScale, t),
      backdropDim: 0.16 * t,
      backdropRadius: _lerp(0, 18, t),
      openHeight: frame.openHeight,
    );
  }
}

double _lerp(double a, double b, double t) => a + (b - a) * t;

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
