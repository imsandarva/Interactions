import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/app/theme/app_colors.dart';

/// Warm paper, a lighter card, near-black ink. Light theme only.
abstract final class PlacesColors {
  static const paper = AppColors.paper;
  static const surface = Color(0xFFFFFCF8);
  static const ink = AppColors.ink;
  static const inkSoft = AppColors.inkSoft;
  static const inkBody = Color(0xFF3C3834);
  static const line = AppColors.line;
  static const scrim = Color(0xFF1C1A17);
  static const inkPressed = Color(0xFF2C2926);
  static const onInk = AppColors.paper;
}

abstract final class PlacesType {
  static const header = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 34,
    height: 1.12,
    letterSpacing: -0.8,
    color: PlacesColors.ink,
  );
  static const headerNote = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 1.35,
    letterSpacing: -0.1,
    color: PlacesColors.inkSoft,
  );
  static const meta = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.3,
    letterSpacing: -0.05,
    color: PlacesColors.inkSoft,
  );
  static const body = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.55,
    letterSpacing: -0.15,
    color: PlacesColors.inkBody,
  );
  static const caption = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12.5,
    height: 1.3,
    letterSpacing: 0.1,
    color: PlacesColors.inkSoft,
  );
  static const value = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.25,
    letterSpacing: -0.2,
    color: PlacesColors.ink,
  );
  static const save = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1,
    letterSpacing: -0.2,
    color: PlacesColors.onInk,
  );

  static TextStyle title(double size) {
    return TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      fontSize: size,
      height: 1.15,
      letterSpacing: size >= 28 ? -0.7 : -0.4,
      color: PlacesColors.ink,
    );
  }

  static TextStyle metaSized(double size) => meta.copyWith(fontSize: size);
}

abstract final class PlacesStatus {
  static const dark = SystemUiOverlayStyle(
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: PlacesColors.paper,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );
  static const light = SystemUiOverlayStyle(
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: PlacesColors.surface,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );
}
