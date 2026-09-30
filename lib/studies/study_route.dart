import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:interactions/studies/study.dart';

/// Native push: edge swipe back on iPhone, predictive back on Android.
Route<void> studyRoute(BuildContext context, Study study) {
  return switch (Theme.of(context).platform) {
    TargetPlatform.iOS ||
    TargetPlatform.macOS => CupertinoPageRoute<void>(builder: study.page),
    _ => MaterialPageRoute<void>(builder: study.page),
  };
}
