import 'package:flutter/widgets.dart';

import 'package:interactions/app/theme/app_colors.dart';
import 'package:interactions/home/widgets/home_empty.dart';
import 'package:interactions/home/widgets/study_list.dart';
import 'package:interactions/studies/study.dart';

const _cardShape = BorderRadius.all(Radius.circular(28));

class StudyIndex extends StatelessWidget {
  const StudyIndex({required this.studies, super.key});

  final List<Study> studies;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: _cardShape,
        border: Border.fromBorderSide(BorderSide(color: AppColors.line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x121C1A17),
            blurRadius: 32,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: _cardShape,
        child: studies.isEmpty
            ? const HomeEmpty()
            : StudyList(studies: studies),
      ),
    );
  }
}
