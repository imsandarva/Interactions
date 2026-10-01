import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/copy/feedback_copy.dart';
import 'package:interactions/studies/feedback/motion/feedback_spec.dart';

/// A quiet grabber, and a close control that takes the deep mood color.
class SheetHeader extends StatelessWidget {
  const SheetHeader({required this.mark, required this.grabber, required this.fill, required this.onClose, super.key});

  final Color mark;
  final Color grabber;
  final Color fill;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _Grabber(color: grabber),
          Align(alignment: Alignment.centerRight, child: _Close(color: mark, fill: fill, onClose: onClose)),
        ],
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(FeedbackSpec.grabberHeight)),
      ),
      child: const SizedBox(width: FeedbackSpec.grabberWidth, height: FeedbackSpec.grabberHeight),
    );
  }
}

class _Close extends StatelessWidget {
  const _Close({required this.color, required this.fill, required this.onClose});

  final Color color;
  final Color fill;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: FeedbackCopy.close,
      child: GestureDetector(
        key: const Key('feedback-close'),
        behavior: HitTestBehavior.opaque,
        onTap: onClose,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
              child: SizedBox(
                width: 32,
                height: 32,
                child: CustomPaint(painter: _XMark(color)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _XMark extends CustomPainter {
  const _XMark(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const inset = 11.0;
    canvas.drawLine(const Offset(inset, inset), Offset(size.width - inset, size.height - inset), paint);
    canvas.drawLine(Offset(size.width - inset, inset), Offset(inset, size.height - inset), paint);
  }

  @override
  bool shouldRepaint(_XMark oldDelegate) => oldDelegate.color != color;
}
