import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:interactions/app/theme/app_colors.dart';
import 'package:interactions/app/theme/app_type.dart';
import 'package:interactions/studies/study.dart';
import 'package:interactions/studies/study_route.dart';

class StudyRow extends StatefulWidget {
  const StudyRow({required this.number, required this.study, super.key});

  final int number;
  final Study study;

  @override
  State<StudyRow> createState() => _StudyRowState();
}

class _StudyRowState extends State<StudyRow> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _open() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(studyRoute(context, widget.study));
  }

  @override
  Widget build(BuildContext context) {
    final number = formatStudyNumber(widget.number);
    return Semantics(
      button: true,
      label: '$number. ${widget.study.title}. ${widget.study.note}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: _open,
        child: AnimatedScale(
          scale: _pressed ? 0.985 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            color: _pressed ? AppColors.press : const Color(0x00000000),
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: ExcludeSemantics(
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(number, style: AppType.number),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.study.title, style: AppType.rowTitle),
                        const SizedBox(height: 3),
                        Text(widget.study.note, style: AppType.rowNote),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
