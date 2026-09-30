import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/payment/motion/pay_timing.dart';
import 'package:interactions/studies/payment/sheet/rolling_text.dart';
import 'package:interactions/studies/payment/theme/pay_style.dart';

/// The dark pill left behind in the thumb's resting spot. Press only, for now.
class CommitButton extends StatefulWidget {
  const CommitButton({required this.label, super.key});

  final String label;

  @override
  State<CommitButton> createState() => _CommitButtonState();
}

class _CommitButtonState extends State<CommitButton> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          _setPressed(true);
          HapticFeedback.lightImpact();
        },
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _pressed ? PayTiming.pressScale : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _pressed ? PayColors.inkPressed : PayColors.ink,
              borderRadius: const BorderRadius.all(Radius.circular(32)),
            ),
            child: SizedBox(
              height: 64,
              width: double.infinity,
              child: Center(
                child: RollingText(
                  text: widget.label,
                  style: PayType.pill,
                  align: Alignment.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
