import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/studies/places/copy/places.dart';
import 'package:interactions/studies/places/memory/place_memory.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';
import 'package:interactions/studies/places/theme/places_style.dart';

/// Fills with the place's deep tone, then settles into "Saved".
class PlaceSave extends StatefulWidget {
  const PlaceSave({required this.place, required this.surface, super.key});

  final Place place;
  final Color surface;

  @override
  State<PlaceSave> createState() => _PlaceSaveState();
}

class _PlaceSaveState extends State<PlaceSave> with TickerProviderStateMixin {
  late final AnimationController _fill = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  var _pressed = false;
  PlaceMemory get _memory => PlaceMemory.instance;

  @override
  void initState() {
    super.initState();
    _fill.value = _memory.isSaved(widget.place.id) ? 1 : 0;
    _memory.addListener(_sync);
  }

  void _sync() {
    final saved = _memory.isSaved(widget.place.id);
    if (saved && _fill.value == 1) return;
    if (!saved && _fill.value == 0 && !_fill.isAnimating) return;
    saved ? _fill.forward() : _fill.reverse();
    _pulse.forward(from: 0);
  }

  @override
  void dispose() {
    _memory.removeListener(_sync);
    _fill.dispose();
    _pulse.dispose();
    super.dispose();
  }

  void _tap() {
    final willSave = !_memory.isSaved(widget.place.id);
    _memory.toggleSaved(widget.place.id);
    if (willSave) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deep = widget.place.tone.deep;
    final quiet = Color.lerp(widget.surface, widget.place.tone.tone, 0.14)!;
    return AnimatedBuilder(
      animation: Listenable.merge([_fill, _pulse]),
      builder: (context, _) {
        final t = _fill.value;
        final pulse = 1 + 0.01 * (1 - (2 * _pulse.value - 1).abs());
        final saved = t > 0.5;
        return Semantics(
          button: true,
          label: saved ? 'Saved' : 'Save this place',
          child: GestureDetector(
            key: const Key('place-save'),
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: _tap,
            child: Transform.scale(
              scale:
                  (_pressed ? PlacesSpec.pressScale : 1) *
                  (_pulse.isAnimating ? pulse : 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color.lerp(deep, quiet, t),
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                ),
                child: SizedBox(
                  height: 64,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (t > 0) ...[
                        CustomPaint(
                          size: const Size(18, 18),
                          painter: _Check(
                            t,
                            Color.lerp(PlacesColors.onInk, deep, t)!,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        t > 0.5 ? 'Saved' : 'Save this place',
                        style: PlacesType.save.copyWith(
                          color: Color.lerp(PlacesColors.onInk, deep, t),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Check extends CustomPainter {
  const _Check(this.t, this.color);

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(size.width * 0.16, size.height * 0.52)
      ..lineTo(size.width * 0.40, size.height * 0.76)
      ..lineTo(size.width * 0.84, size.height * 0.28);
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * t.clamp(0, 1)),
      paint,
    );
  }

  @override
  bool shouldRepaint(_Check oldDelegate) =>
      oldDelegate.t != t || oldDelegate.color != color;
}
