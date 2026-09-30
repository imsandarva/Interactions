import 'package:flutter/widgets.dart';

/// A single practice piece, opened from its number on the home screen.
class Study {
  const Study({required this.title, required this.note, required this.page});

  final String title;
  final String note;
  final WidgetBuilder page;
}

/// Home numbers start at 01.
String formatStudyNumber(int number) => number.toString().padLeft(2, '0');
