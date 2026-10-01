import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/invite/give_feedback_button.dart';
import 'package:interactions/studies/feedback/stage/feedback_glow.dart';
import 'package:interactions/studies/feedback/stage/feedback_intro.dart';

/// Glow, words, and the invitation, in that order.
class FeedbackStage extends StatelessWidget {
  const FeedbackStage({required this.onGiveFeedback, super.key});

  final VoidCallback onGiveFeedback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(top: -40, right: -70, child: FeedbackGlow()),
        SafeArea(child: _body()),
      ],
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FeedbackIntro(),
          const Spacer(),
          GiveFeedbackButton(onPressed: onGiveFeedback),
        ],
      ),
    );
  }
}
