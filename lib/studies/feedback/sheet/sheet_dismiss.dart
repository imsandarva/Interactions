import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/motion/sheet_rise.dart';

/// Drags that start here follow the finger. The slider never uses this.
class SheetDismiss extends StatelessWidget {
  const SheetDismiss({required this.rise, required this.travel, required this.child, super.key});

  final SheetRise rise;
  final double travel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (d) => rise.dragBy(d.delta.dy, travel),
      onVerticalDragEnd: (d) => rise.endDrag(d.velocity.pixelsPerSecond.dy, travel),
      child: child,
    );
  }
}
