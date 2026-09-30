import 'package:flutter/widgets.dart';

/// One short entrance for the whole home screen. Shares a single ticker.
class HomeMotion extends StatefulWidget {
  const HomeMotion({required this.child, super.key});

  final Widget child;

  @override
  State<HomeMotion> createState() => _HomeMotionState();
}

class _HomeMotionState extends State<HomeMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 880),
  );
  var _configured = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_configured) return;
    _configured = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _HomeMotionScope(animation: _controller, child: widget.child);
}

class _HomeMotionScope extends InheritedWidget {
  const _HomeMotionScope({required this.animation, required super.child});

  final Animation<double> animation;

  static Animation<double> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_HomeMotionScope>()!.animation;

  @override
  bool updateShouldNotify(_HomeMotionScope oldWidget) =>
      animation != oldWidget.animation;
}

/// Fades and lifts a slice of the entrance across [begin]–[end] of the parent motion.
class EntranceSlice extends StatelessWidget {
  const EntranceSlice({
    required this.begin,
    required this.end,
    required this.child,
    super.key,
  });

  final double begin;
  final double end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = _HomeMotionScope.of(context);
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_span(animation.value));
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 12),
            child: child,
          ),
        );
      },
    );
  }

  double _span(double t) {
    if (t <= begin) return 0;
    if (t >= end) return 1;
    return (t - begin) / (end - begin);
  }
}
