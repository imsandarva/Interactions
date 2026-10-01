import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/copy/feedback_copy.dart';
import 'package:interactions/studies/feedback/mood/mood.dart';
import 'package:interactions/studies/feedback/motion/feedback_spec.dart';
import 'package:interactions/studies/feedback/motion/mood_track.dart';
import 'package:interactions/studies/feedback/theme/feedback_style.dart';
import 'package:interactions/studies/feedback/theme/mood_palette.dart';

/// Three stops, one thumb. Taps land on a stop. Drags follow the finger.
class MoodSlider extends StatefulWidget {
  const MoodSlider({required this.mood, super.key});

  final MoodTrack mood;

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> with SingleTickerProviderStateMixin {
  late final AnimationController _over = AnimationController.unbounded(vsync: this, value: 0);
  double _pointer = 0.5;
  var _grabbed = false;

  @override
  void dispose() {
    _over.dispose();
    super.dispose();
  }

  void _start() {
    _pointer = widget.mood.goal;
    _grabbed = true;
    _over.stop();
    _over.value = 0;
    widget.mood.beginDrag();
  }

  void _move(double dx, double travel) {
    _pointer += dx / travel;
    final extra = _pointer < 0 ? _pointer : (_pointer > 1 ? _pointer - 1 : 0.0);
    final px = (extra * travel * 0.28).clamp(-FeedbackSpec.rubber, FeedbackSpec.rubber);
    _over.stop();
    _over.value = widget.mood.reduced ? 0 : px;
    widget.mood.moveTo(_pointer);
  }

  void _finish(double vx, double travel) {
    _grabbed = false;
    _over.animateTo(0, duration: FeedbackSpec.overscroll, curve: Curves.easeOut);
    widget.mood.endDrag(vx / travel);
  }

  void _tap(double x, double width) {
    final travel = math.max(width - FeedbackSpec.thumb, 1.0);
    final raw = ((x - FeedbackSpec.thumb / 2) / travel).clamp(0.0, 1.0);
    _grabbed = false;
    widget.mood.jumpTo(nearestMood(raw).anchor);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _over,
      builder: (context, _) => _body(),
    );
  }

  Widget _body() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final travel = math.max(width - FeedbackSpec.thumb, 1.0);
        widget.mood.setTravel(travel);
        final tone = MoodPalette.at(widget.mood.value);
        final up = widget.mood.current.towardGreat;
        final down = widget.mood.current.towardBad;
        return Semantics(
          slider: true,
          label: FeedbackCopy.question,
          value: widget.mood.current.label,
          increasedValue: up?.label,
          decreasedValue: down?.label,
          onIncrease: up == null ? null : () => widget.mood.jumpTo(up.anchor),
          onDecrease: down == null ? null : () => widget.mood.jumpTo(down.anchor),
          child: GestureDetector(
            key: const Key('mood-slider'),
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (_) => _start(),
            onHorizontalDragUpdate: (d) => _move(d.delta.dx, travel),
            onHorizontalDragEnd: (d) => _finish(d.velocity.pixelsPerSecond.dx, travel),
            onHorizontalDragCancel: () => _finish(0, travel),
            onTapUp: (d) => _tap(d.localPosition.dx, width),
            child: ExcludeSemantics(child: _track(travel, tone)),
          ),
        );
      },
    );
  }

  Widget _track(double travel, MoodPalette tone) {
    final x = FeedbackSpec.thumb / 2 + widget.mood.value * travel + _over.value;
    final scale = _grabbed && !widget.mood.reduced ? FeedbackSpec.thumbGrab : 1.0;
    return Column(
      children: [
        SizedBox(
          height: 64,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              CustomPaint(
                painter: _TrackPainter(track: tone.track, dot: tone.dot, active: widget.mood.current),
                child: const SizedBox(height: 64, width: double.infinity),
              ),
              Positioned(
                left: x - FeedbackSpec.thumb / 2,
                child: _Thumb(color: tone.deep, scale: scale, grabbed: _grabbed),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _Captions(tone: tone, active: widget.mood.current),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.color, required this.scale, required this.grabbed});

  final Color color;
  final double scale;
  final bool grabbed;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: FeedbackSpec.press,
      curve: Curves.easeOut,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: FeedbackColors.thumb,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: FeedbackColors.thumbShadow,
              blurRadius: grabbed ? 14 : 10,
              offset: Offset(0, grabbed ? 6 : 4),
            ),
          ],
        ),
        child: SizedBox(
          width: FeedbackSpec.thumb,
          height: FeedbackSpec.thumb,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const SizedBox.square(dimension: 8),
            ),
          ),
        ),
      ),
    );
  }
}

class _Captions extends StatelessWidget {
  const _Captions({required this.tone, required this.active});

  final MoodPalette tone;
  final Mood active;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _caption(Mood.bad, Alignment.centerLeft),
        _caption(Mood.fine, Alignment.center),
        _caption(Mood.great, Alignment.centerRight),
      ],
    );
  }

  Widget _caption(Mood mood, Alignment align) {
    final on = mood == active;
    return Expanded(
      child: Align(
        alignment: align,
        child: Text(
          mood.label,
          style: (on ? FeedbackType.captionOn : FeedbackType.caption).copyWith(
            color: on ? tone.deep : tone.caption,
          ),
        ),
      ),
    );
  }
}

class _TrackPainter extends CustomPainter {
  const _TrackPainter({required this.track, required this.dot, required this.active});

  final Color track;
  final Color dot;
  final Mood active;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final left = FeedbackSpec.thumb / 2;
    final right = size.width - FeedbackSpec.thumb / 2;
    final line = Paint()
      ..color = track
      ..strokeWidth = FeedbackSpec.track
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(left, y), Offset(right, y), line);
    final mark = Paint()..color = dot;
    for (final mood in Mood.values) {
      final x = left + mood.anchor * (right - left);
      final on = mood == active;
      canvas.drawCircle(Offset(x, y), on ? 4.0 : 3.0, mark);
    }
  }

  @override
  bool shouldRepaint(_TrackPainter oldDelegate) =>
      oldDelegate.track != track || oldDelegate.dot != dot || oldDelegate.active != active;
}
