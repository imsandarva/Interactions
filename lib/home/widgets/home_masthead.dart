import 'package:flutter/widgets.dart';

import 'package:interactions/app/theme/app_colors.dart';
import 'package:interactions/app/theme/app_type.dart';

class HomeMasthead extends StatelessWidget {
  const HomeMasthead({required this.dateLabel, super.key});

  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DateMark(label: dateLabel),
        const SizedBox(height: 22),
        const Text('Interactions', style: AppType.display),
        const SizedBox(height: 12),
        const Text('A quiet index of what you try.', style: AppType.subtitle),
      ],
    );
  }
}

class _DateMark extends StatelessWidget {
  const _DateMark({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(dimension: 6),
        ),
        const SizedBox(width: 10),
        Text(label, style: AppType.date),
      ],
    );
  }
}
