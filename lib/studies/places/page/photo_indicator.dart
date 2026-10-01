import 'package:flutter/widgets.dart';

/// Three short bars. The active one fills in; they are not dots.
class PhotoIndicator extends StatelessWidget {
  const PhotoIndicator({required this.count, required this.index, super.key});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 3,
              decoration: BoxDecoration(
                color: Color(i == index ? 0xFFFFFFFF : 0x66FFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
