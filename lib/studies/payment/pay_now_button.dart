import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/app/theme/app_colors.dart';

/// The primary action on the payment screen. Large, full width, easy to hit.
class PayNowButton extends StatefulWidget {
  const PayNowButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  State<PayNowButton> createState() => _PayNowButtonState();
}

class _PayNowButtonState extends State<PayNowButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  var _pressed = false;
  var _configured = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_configured) return;
    _configured = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _enter.value = 1;
    } else {
      _enter.forward();
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _tap() {
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _enter,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_enter.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 10),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: _tap,
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _pressed ? const Color(0xFF2A2724) : AppColors.ink,
              borderRadius: const BorderRadius.all(Radius.circular(18)),
            ),
            child: const SizedBox(
              width: double.infinity,
              height: 64,
              child: Center(child: Text('Pay now', style: _label)),
            ),
          ),
        ),
      ),
    );
  }
}

const _label = TextStyle(
  inherit: false,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w600,
  fontSize: 18,
  height: 1,
  letterSpacing: -0.2,
  color: AppColors.paper,
  decoration: TextDecoration.none,
);
