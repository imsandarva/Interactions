import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/mood/mood.dart';
import 'package:interactions/studies/feedback/motion/feedback_spec.dart';
import 'package:interactions/studies/feedback/theme/feedback_style.dart';

/// One word. It leaves against the drag and the next word arrives with it.
class MoodWord extends StatefulWidget {
  const MoodWord({required this.mood, required this.direction, required this.color, required this.reduced, super.key});

  final Mood mood;
  final int direction;
  final Color color;
  final bool reduced;

  @override
  State<MoodWord> createState() => _MoodWordState();
}

class _MoodWordState extends State<MoodWord> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: FeedbackSpec.word, value: 1);
  late Mood _from = widget.mood;

  @override
  void didUpdateWidget(MoodWord oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood == widget.mood) return;
    _from = oldWidget.mood;
    if (widget.reduced) {
      _ctrl.value = 1;
      return;
    }
    _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.textScalerOf(context).scale(38);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => _line(height),
    );
  }

  Widget _line(double height) {
    final t = Curves.easeOutCubic.transform(_ctrl.value);
    final drag = widget.direction == 0 ? 1.0 : widget.direction.toDouble();
    return SizedBox(
      height: height,
      child: ClipRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (t < 1) _text(_from.label, opacity: 1 - t, dx: -drag * FeedbackSpec.wordSlide * t),
            _text(widget.mood.label, opacity: t, dx: drag * FeedbackSpec.wordSlide * (1 - t), keyed: true),
          ],
        ),
      ),
    );
  }

  Widget _text(String label, {required double opacity, required double dx, bool keyed = false}) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(dx, 0),
        child: Text(
          label,
          key: keyed ? const Key('mood-word') : null,
          style: FeedbackType.moodWord.copyWith(color: widget.color),
        ),
      ),
    );
  }
}
