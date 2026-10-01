import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/theme/places_style.dart';

/// A small white disc over the photograph.
class PlaceClose extends StatelessWidget {
  const PlaceClose({
    required this.onPressed,
    this.onPressDown,
    this.onPressCancel,
    super.key,
  });

  final VoidCallback onPressed;
  final VoidCallback? onPressDown;
  final VoidCallback? onPressCancel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Close',
      child: GestureDetector(
        key: const Key('place-close'),
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => onPressDown?.call(),
        onTapCancel: onPressCancel,
        onTap: onPressed,
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xEBFFFCF8),
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: Color(0x241C1A17)),
                ),
              ),
              child: SizedBox(
                width: 42,
                height: 42,
                child: CustomPaint(painter: _Mark()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Mark extends CustomPainter {
  const _Mark();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PlacesColors.ink
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const inset = 15.0;
    canvas.drawLine(
      const Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(_Mark oldDelegate) => false;
}
