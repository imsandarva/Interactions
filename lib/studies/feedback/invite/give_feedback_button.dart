import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/copy/feedback_copy.dart';
import 'package:interactions/studies/feedback/theme/feedback_style.dart';

/// The invitation. A short press, then the sheet takes over.
class GiveFeedbackButton extends StatefulWidget {
  const GiveFeedbackButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  State<GiveFeedbackButton> createState() => _GiveFeedbackButtonState();
}

class _GiveFeedbackButtonState extends State<GiveFeedbackButton> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _down() {
    _setPressed(true);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) => _button();

  Widget _button() {
    return Semantics(
      button: true,
      label: FeedbackCopy.action,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _down(),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.975 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: _fill(),
        ),
      ),
    );
  }

  Widget _fill() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _pressed ? FeedbackColors.inkPressed : FeedbackColors.ink,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [_shadow()],
      ),
      child: const Text(FeedbackCopy.action, style: FeedbackType.action),
    );
  }

  BoxShadow _shadow() {
    return BoxShadow(
      color: FeedbackColors.lift,
      blurRadius: _pressed ? 10 : 22,
      offset: Offset(0, _pressed ? 4 : 12),
    );
  }
}
