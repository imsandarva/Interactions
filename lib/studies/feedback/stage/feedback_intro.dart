import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/copy/feedback_copy.dart';
import 'package:interactions/studies/feedback/theme/feedback_style.dart';

/// The mark, the line, and the promise. No choices yet.
class FeedbackIntro extends StatelessWidget {
  const FeedbackIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeedbackMark(),
        SizedBox(height: 36),
        Text(FeedbackCopy.headline, style: FeedbackType.headline),
        SizedBox(height: 18),
        Text(FeedbackCopy.body, style: FeedbackType.body),
      ],
    );
  }
}

class FeedbackMark extends StatelessWidget {
  const FeedbackMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: FeedbackColors.accent, shape: BoxShape.circle),
          child: SizedBox.square(dimension: 6),
        ),
        SizedBox(width: 10),
        Text(FeedbackCopy.mark, style: FeedbackType.mark),
      ],
    );
  }
}
