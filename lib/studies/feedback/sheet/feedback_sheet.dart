import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/copy/feedback_copy.dart';
import 'package:interactions/studies/feedback/face/mood_face.dart';
import 'package:interactions/studies/feedback/motion/feedback_spec.dart';
import 'package:interactions/studies/feedback/motion/mood_track.dart';
import 'package:interactions/studies/feedback/motion/sheet_rise.dart';
import 'package:interactions/studies/feedback/sheet/mood_slider.dart';
import 'package:interactions/studies/feedback/sheet/mood_word.dart';
import 'package:interactions/studies/feedback/sheet/send_button.dart';
import 'package:interactions/studies/feedback/sheet/sheet_dismiss.dart';
import 'package:interactions/studies/feedback/sheet/sheet_header.dart';
import 'package:interactions/studies/feedback/theme/feedback_style.dart';
import 'package:interactions/studies/feedback/theme/mood_palette.dart';

/// Question, face, word, slider, send. Color comes from the same value as the face.
class FeedbackSheet extends StatelessWidget {
  const FeedbackSheet({
    required this.mood,
    required this.rise,
    required this.onClose,
    required this.onSend,
    required this.travel,
    super.key,
  });

  final MoodTrack mood;
  final SheetRise rise;
  final VoidCallback onClose;
  final VoidCallback onSend;
  final double travel;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return AnimatedBuilder(
      animation: mood,
      builder: (context, _) => _shell(bottom),
    );
  }

  Widget _shell(double bottom) {
    final tone = MoodPalette.at(mood.value);
    return DecoratedBox(
      key: const Key('feedback-sheet'),
      decoration: BoxDecoration(
        color: tone.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(FeedbackSpec.radius)),
        boxShadow: const [BoxShadow(color: Color(0x141C1A17), blurRadius: 24, offset: Offset(0, -8))],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(FeedbackSpec.radius)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(FeedbackSpec.padH, 6, FeedbackSpec.padH, 16 + bottom),
          child: _column(tone),
        ),
      ),
    );
  }

  Widget _column(MoodPalette tone) {
    return Column(
      children: [
        Expanded(child: _hero(tone)),
        const SizedBox(height: 4),
        MoodWord(mood: mood.current, direction: mood.direction, color: tone.deep, reduced: mood.reduced),
        const SizedBox(height: 8),
        MoodSlider(mood: mood),
        const SizedBox(height: 16),
        SendButton(mood: mood, onSend: onSend),
      ],
    );
  }

  Widget _hero(MoodPalette tone) {
    return SheetDismiss(
      rise: rise,
      travel: travel,
      child: Column(
        children: [
          SheetHeader(mark: tone.deep, grabber: tone.grabber, fill: tone.closeFill, onClose: onClose),
          const SizedBox(height: 2),
          ExcludeSemantics(
            child: Text(
              FeedbackCopy.question,
              textAlign: TextAlign.center,
              style: FeedbackType.question.copyWith(color: tone.deep),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: MoodFace(
              mood: mood.value,
              dragging: mood.dragging,
              openness: rise.t,
              reduced: mood.reduced,
              color: tone.deep,
            ),
          ),
        ],
      ),
    );
  }
}
