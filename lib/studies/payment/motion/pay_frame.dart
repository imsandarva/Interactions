import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Resting pill and open sheet, in one place so the morph stays easy to tune.
abstract final class PayFrame {
  static const pillHeight = 64.0;
  static const sheetRadius = 28.0;
  static const pillRadius = 32.0;
  static const gutter = 24.0;
  static const bottomGap = 16.0;
  static const backdropScale = 0.955;

  static FrameMetrics of(MediaQueryData media) {
    final scale = media.textScaler.scale(16) / 16;
    final screen = media.size;
    final safe = media.padding;
    final fraction = (0.75 + (scale - 1) * 0.28).clamp(0.75, 0.92);
    final maxH = math.max(pillHeight, screen.height - safe.top - 10);
    final open = (screen.height * fraction).clamp(pillHeight, maxH);
    return FrameMetrics(
      screen: screen,
      safe: safe,
      openHeight: open,
      side: gutter + math.max(safe.left, safe.right),
      restBottom: safe.bottom + bottomGap,
    );
  }
}

class FrameMetrics {
  const FrameMetrics({
    required this.screen,
    required this.safe,
    required this.openHeight,
    required this.side,
    required this.restBottom,
  });

  final Size screen;
  final EdgeInsets safe;
  final double openHeight;
  final double side;
  final double restBottom;

  double get travel => math.max(1, openHeight - PayFrame.pillHeight);

  /// At least the resting 75%, taller when the offer needs the room.
  FrameMetrics sized(double content) {
    if (content <= 0) return this;
    final cap = math.max(PayFrame.pillHeight, screen.height - safe.top - 12);
    final open = math.max(openHeight, content).clamp(PayFrame.pillHeight, cap);
    return FrameMetrics(
      screen: screen,
      safe: safe,
      openHeight: open,
      side: side,
      restBottom: restBottom,
    );
  }
}
