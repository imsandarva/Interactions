import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/theme/places_style.dart';

/// A small bookmark that settles onto a photo after the card lands.
class SavedMark extends StatelessWidget {
  const SavedMark({required this.t, super.key});

  /// 0 hidden, 1 resting.
  final double t;

  @override
  Widget build(BuildContext context) {
    final shown = t.clamp(0.0, 1.0);
    return IgnorePointer(
      child: Opacity(
        opacity: shown,
        child: Transform.scale(
          scale: 0.6 + 0.4 * shown,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xD6FFFCF8),
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 32,
              height: 32,
              child: CustomPaint(painter: _Bookmark()),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bookmark extends CustomPainter {
  const _Bookmark();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.32, size.height * 0.22)
      ..lineTo(size.width * 0.68, size.height * 0.22)
      ..lineTo(size.width * 0.68, size.height * 0.78)
      ..lineTo(size.width * 0.50, size.height * 0.62)
      ..lineTo(size.width * 0.32, size.height * 0.78)
      ..close();
    canvas.drawPath(path, Paint()..color = PlacesColors.ink);
  }

  @override
  bool shouldRepaint(_Bookmark oldDelegate) => false;
}
