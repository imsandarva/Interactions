import 'package:flutter/physics.dart';

/// Every timing and size for this study. Tune these on a phone, not in a hurry.
abstract final class FeedbackSpec {
  static const followTau = 0.042;
  static const open = Duration(milliseconds: 420);
  static const close = Duration(milliseconds: 320);
  static const reduced = Duration(milliseconds: 170);
  static const wake = Duration(milliseconds: 220);
  static const blink = Duration(milliseconds: 160);
  static const word = Duration(milliseconds: 200);
  static const sendOn = Duration(milliseconds: 250);
  static const thanksHold = Duration(milliseconds: 900);
  static const hintDelay = Duration(milliseconds: 1500);
  static const nudge = Duration(milliseconds: 520);
  static const grab = Duration(milliseconds: 180);
  static const press = Duration(milliseconds: 120);
  static const overscroll = Duration(milliseconds: 180);

  static const pressScale = 0.975;
  static const faceGrab = 0.02;
  static const thumbGrab = 1.08;
  static const wakeAt = 0.86;
  static const wordSlide = 16.0;
  static const nudgePx = 10.0;
  static const rubber = 14.0;
  static const flick = 1.15;
  static const sheetFlick = 900.0;
  static const dismissAt = 0.68;
  static const dragResistance = 0.92;

  static const radius = 32.0;
  static const padH = 24.0;
  static const thumb = 48.0;
  static const track = 6.0;
  static const button = 60.0;
  static const grabberWidth = 36.0;
  static const grabberHeight = 4.0;

  static final settleSpring = SpringDescription.withDurationAndBounce(
    duration: const Duration(milliseconds: 330),
    bounce: 0,
  );
  static final sheetSpring = SpringDescription.withDurationAndBounce(
    duration: const Duration(milliseconds: 340),
    bounce: 0,
  );

  /// About half the screen, taller only when type or a short phone needs it.
  static double sheetHeight(double screen, double textScale, double bottom) {
    final scale = textScale.clamp(1.0, 1.6);
    final chrome = 286 + bottom + (scale - 1) * 150;
    final face = 120.0 * (screen / 844).clamp(0.8, 1.05);
    return (chrome + face).clamp(screen * 0.50, screen * 0.86);
  }
}
