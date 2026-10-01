import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';

/// A soft color field standing in until a photograph is dropped in.
class PlaceField extends StatelessWidget {
  const PlaceField({required this.tone, super.key});

  final PlaceTone tone;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _FieldPainter(tone),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _FieldPainter extends CustomPainter {
  const _FieldPainter(this.tone);

  final PlaceTone tone;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = tone.base);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tone.glow, tone.base, tone.shade],
          stops: const [0, 0.46, 1],
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: tone.focal,
          radius: 0.9,
          colors: [
            tone.glow.withValues(alpha: 0.72),
            tone.glow.withValues(alpha: 0),
          ],
        ).createShader(rect),
    );
    canvas.save();
    canvas.scale(size.width / _Grain.w, size.height / _Grain.h);
    canvas.drawPicture(_Grain.of(tone.seed));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_FieldPainter oldDelegate) => oldDelegate.tone != tone;
}

/// One tiny grain plate per tone, scaled up. Never rebuilt per frame.
abstract final class _Grain {
  static const w = 180.0;
  static const h = 240.0;
  static final _cache = <int, ui.Picture>{};

  static ui.Picture of(int seed) {
    return _cache.putIfAbsent(seed, () {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final random = math.Random(seed);
      final light = Paint();
      final dark = Paint();
      for (var i = 0; i < 700; i++) {
        final x = random.nextDouble() * w;
        final y = random.nextDouble() * h;
        final speck = random.nextDouble();
        final paint = speck > 0.5 ? light : dark;
        paint.color = speck > 0.5
            ? const Color(
                0xFFFFFFFF,
              ).withValues(alpha: 0.015 + random.nextDouble() * 0.04)
            : const Color(
                0xFF1C1A17,
              ).withValues(alpha: 0.012 + random.nextDouble() * 0.03);
        canvas.drawRect(Rect.fromLTWH(x, y, 1.15, 1.15), paint);
      }
      return recorder.endRecording();
    });
  }
}
