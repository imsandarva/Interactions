import 'package:flutter/widgets.dart';

import 'package:interactions/app/theme/app_type.dart';

class StudyCount extends StatelessWidget {
  const StudyCount({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Studies', style: AppType.label),
        const Spacer(),
        Text(count == 0 ? 'None yet' : '$count', style: AppType.labelMuted),
      ],
    );
  }
}
