import 'package:flutter/material.dart';

import 'package:interactions/studies/feedback/stage/feedback_stage.dart';
import 'package:interactions/studies/feedback/theme/feedback_style.dart';

/// Study 02. The invitation only. The prompt attaches at [_hold] later.
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  /// Acknowledges the tap and goes nowhere until Bad, Fine, and Great exist.
  static void _hold() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FeedbackColors.paper,
      body: FeedbackStage(onGiveFeedback: _hold),
    );
  }
}
