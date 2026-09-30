import 'package:flutter/widgets.dart';

import 'package:interactions/studies/payment/theme/pay_style.dart';

class SheetClose extends StatelessWidget {
  const SheetClose({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Close',
      child: GestureDetector(
        key: const Key('pay-close'),
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Center(child: _Mark()),
        ),
      ),
    );
  }
}

class _Mark extends StatelessWidget {
  const _Mark();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PayColors.tint,
        shape: BoxShape.circle,
        border: Border.all(color: PayColors.line),
      ),
      child: const SizedBox(
        width: 32,
        height: 32,
        child: CustomPaint(painter: _XPainter()),
      ),
    );
  }
}

class _XPainter extends CustomPainter {
  const _XPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PayColors.inkSoft
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const inset = 11.0;
    canvas.drawLine(const Offset(inset, inset), Offset(size.width - inset, size.height - inset), paint);
    canvas.drawLine(Offset(size.width - inset, inset), Offset(inset, size.height - inset), paint);
  }

  @override
  bool shouldRepaint(_XPainter oldDelegate) => false;
}
