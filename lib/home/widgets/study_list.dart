import 'package:flutter/widgets.dart';

import 'package:interactions/app/theme/app_colors.dart';
import 'package:interactions/home/widgets/study_row.dart';
import 'package:interactions/studies/study.dart';

class StudyList extends StatelessWidget {
  const StudyList({required this.studies, super.key});

  final List<Study> studies;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      itemCount: studies.length,
      separatorBuilder: (context, index) =>
          const ColoredBox(color: AppColors.line, child: SizedBox(height: 1)),
      itemBuilder: (context, index) =>
          StudyRow(number: index + 1, study: studies[index]),
    );
  }
}
