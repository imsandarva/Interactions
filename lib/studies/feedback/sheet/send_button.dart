import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/copy/feedback_copy.dart';
import 'package:interactions/studies/feedback/motion/feedback_spec.dart';
import 'package:interactions/studies/feedback/motion/mood_track.dart';
import 'package:interactions/studies/feedback/theme/feedback_style.dart';
import 'package:interactions/studies/feedback/theme/mood_palette.dart';

/// Quiet until the slider is touched, then the same near-black pill as the invitation.
class SendButton extends StatefulWidget {
  const SendButton({required this.mood, required this.onSend, super.key});

  final MoodTrack mood;
  final VoidCallback onSend;

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> with SingleTickerProviderStateMixin {
  late final AnimationController _on = AnimationController(vsync: this, duration: FeedbackSpec.sendOn);
  var _pressed = false;
  var _wasTouched = false;

  void _syncTouch() {
    final touched = widget.mood.touched;
    if (touched == _wasTouched) return;
    _wasTouched = touched;
    if (!touched) {
      _on.value = 0;
      return;
    }
    if (widget.mood.reduced) {
      _on.value = 1;
      return;
    }
    _on.forward();
  }

  @override
  void didUpdateWidget(SendButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTouch();
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  bool get _live => widget.mood.touched && !widget.mood.thanks;

  void _down() {
    if (!_live) return;
    _setPressed(true);
    HapticFeedback.lightImpact();
  }

  void _up() => _setPressed(false);

  void _send() {
    if (!_live) return;
    widget.onSend();
  }

  @override
  void dispose() {
    _on.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _on,
      builder: (context, _) => _pill(),
    );
  }

  Widget _pill() {
    final tone = MoodPalette.at(widget.mood.value);
    final t = widget.mood.reduced ? (widget.mood.touched ? 1.0 : 0.0) : _on.value;
    final fill = Color.lerp(tone.inactiveFill, FeedbackColors.ink, t)!;
    final label = Color.lerp(tone.inactiveLabel, FeedbackColors.onInk, t)!;
    final color = _pressed && _live ? FeedbackColors.inkPressed : fill;
    final scale = _pressed && _live ? FeedbackSpec.pressScale : 1.0;
    return Semantics(
      button: true,
      enabled: _live,
      child: GestureDetector(
        key: const Key('feedback-send'),
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _down(),
        onTapUp: (_) => _up(),
        onTapCancel: _up,
        onTap: _live ? _send : null,
        child: AnimatedScale(
          scale: scale,
          duration: FeedbackSpec.press,
          curve: Curves.easeOut,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: SizedBox(
              height: FeedbackSpec.button,
              width: double.infinity,
              child: Center(child: _label(label)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(Color color) {
    final thanks = widget.mood.thanks;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Text(
        thanks ? FeedbackCopy.thanks : FeedbackCopy.send,
        key: ValueKey(thanks),
        style: FeedbackType.action.copyWith(color: color),
      ),
    );
  }
}
