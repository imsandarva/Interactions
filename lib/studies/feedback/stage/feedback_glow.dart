import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/theme/feedback_style.dart';

/// A soft clay wash behind the headline. It does not take taps.
class FeedbackGlow extends StatelessWidget {
  const FeedbackGlow({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [FeedbackColors.glow, FeedbackColors.glowFade],
            stops: [0.15, 1],
          ),
        ),
        child: SizedBox.square(dimension: 300),
      ),
    );
  }
}
