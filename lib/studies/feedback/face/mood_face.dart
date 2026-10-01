import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/face/face_painter.dart';
import 'package:interactions/studies/feedback/motion/feedback_spec.dart';

/// The hero. Eyes wake once, blink while idle, and grow slightly when the thumb is held.
class MoodFace extends StatefulWidget {
  const MoodFace({
    required this.mood,
    required this.dragging,
    required this.openness,
    required this.reduced,
    required this.color,
    super.key,
  });

  final double mood;
  final bool dragging;
  final double openness;
  final bool reduced;
  final Color color;

  @override
  State<MoodFace> createState() => _MoodFaceState();
}

class _MoodFaceState extends State<MoodFace> with TickerProviderStateMixin {
  late final AnimationController _wake = AnimationController(vsync: this, duration: FeedbackSpec.wake);
  late final AnimationController _blink = AnimationController(vsync: this, duration: FeedbackSpec.blink);
  late final AnimationController _grab = AnimationController(vsync: this, duration: FeedbackSpec.grab);
  late final Listenable _life = Listenable.merge([_wake, _blink, _grab]);
  final _rand = math.Random();
  Timer? _blinkTimer;
  var _woke = false;

  @override
  void initState() {
    super.initState();
    if (widget.reduced) _wake.value = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncWake());
  }

  @override
  void didUpdateWidget(MoodFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncGrab(oldWidget.dragging);
    _syncWake();
  }

  void _syncGrab(bool wasDragging) {
    if (widget.reduced) {
      _grab.value = 0;
      _blinkTimer?.cancel();
      return;
    }
    if (widget.dragging == wasDragging) return;
    if (widget.dragging) {
      _blinkTimer?.cancel();
      _blink.stop();
      _blink.value = 0;
      _grab.animateTo(1, curve: Curves.easeOut);
      return;
    }
    _grab.animateTo(0, curve: Curves.easeOut);
    _armBlink();
  }

  void _syncWake() {
    if (!mounted) return;
    if (widget.reduced) {
      _blinkTimer?.cancel();
      _wake.value = 1;
      return;
    }
    if (widget.openness < 0.05) {
      _woke = false;
      _wake.value = 0;
      _blinkTimer?.cancel();
      return;
    }
    if (widget.openness >= FeedbackSpec.wakeAt && !_woke) {
      _woke = true;
      _wake.forward(from: 0).whenComplete(() {
        if (mounted) _armBlink();
      });
    }
  }

  void _armBlink() {
    _blinkTimer?.cancel();
    if (!mounted || widget.reduced || widget.dragging || widget.openness < FeedbackSpec.wakeAt) return;
    final wait = 4000 + _rand.nextInt(2000);
    _blinkTimer = Timer(Duration(milliseconds: wait), () {
      if (!mounted || widget.dragging || widget.reduced) return;
      _blink.forward(from: 0).whenComplete(() {
        if (mounted) _armBlink();
      });
    });
  }

  double get _eyeOpen {
    if (widget.reduced) return 1;
    final blink = math.sin(_blink.value * math.pi);
    return (_wake.value * (1 - blink)).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _wake.dispose();
    _blink.dispose();
    _grab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return AnimatedBuilder(
      animation: _life,
      builder: (context, _) {
        final grab = widget.reduced ? 0.0 : _grab.value;
        return Transform.scale(
          scale: 1 + FeedbackSpec.faceGrab * grab,
          child: CustomPaint(
            key: const Key('mood-face'),
            painter: FacePainter(
              mood: widget.mood,
              color: widget.color,
              eyeOpen: _eyeOpen,
              sheetWidth: width,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}
