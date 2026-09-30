import 'package:flutter/widgets.dart';

/// Shares the morph progress without rebuilding the sheet on every tick.
class MorphScope extends InheritedWidget {
  const MorphScope({required this.t, required super.child, super.key});

  final double t;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MorphScope>()?.t ?? 0;

  @override
  bool updateShouldNotify(MorphScope oldWidget) => t != oldWidget.t;
}

/// Fades and rises a group. The child itself is not scaled with the sheet.
class Reveal extends StatelessWidget {
  const Reveal({required this.amount, required this.child, super.key});

  final double Function(double t) amount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final local = amount(MorphScope.of(context));
    return IgnorePointer(
      ignoring: local < 0.45,
      child: Opacity(
        opacity: local,
        child: Transform.translate(offset: Offset(0, (1 - local) * 8), child: child),
      ),
    );
  }
}
