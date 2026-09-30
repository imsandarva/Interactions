import 'package:flutter/widgets.dart';

/// Old line leaves upward, new line arrives from below. Digits stay put.
class RollingText extends StatelessWidget {
  const RollingText({
    required this.text,
    required this.style,
    this.align = Alignment.centerLeft,
    this.lines = 1,
    super.key,
  });

  final String text;
  final TextStyle style;
  final Alignment align;
  final int lines;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final size = scaler.scale(style.fontSize ?? 16);
    final height = size * (style.height ?? 1.2) * lines + 2;
    return ClipRect(
      child: SizedBox(
        height: height,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (current, previous) => Stack(
            alignment: align,
            children: [...previous, if (current != null) current],
          ),
          transitionBuilder: (child, animation) {
            final incoming = child.key == ValueKey(text);
            final begin = incoming ? const Offset(0, 0.7) : const Offset(0, -0.7);
            return SlideTransition(
              position: Tween<Offset>(begin: begin, end: Offset.zero).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Text(text, key: ValueKey(text), style: style, maxLines: lines),
        ),
      ),
    );
  }
}
