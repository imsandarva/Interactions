import 'package:flutter/material.dart';

import 'package:interactions/app/theme/app_colors.dart';
import 'package:interactions/home/format_day.dart';
import 'package:interactions/home/widgets/home_masthead.dart';
import 'package:interactions/home/widgets/home_motion.dart';
import 'package:interactions/home/widgets/study_count.dart';
import 'package:interactions/home/widgets/study_index.dart';
import 'package:interactions/studies/study_registry.dart';

/// Composes the index. Studies themselves live in [StudyRegistry].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studies = StudyRegistry.studies;
    return HomeMotion(
      child: Scaffold(
        backgroundColor: AppColors.paper,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EntranceSlice(
                  begin: 0,
                  end: 0.62,
                  child: HomeMasthead(dateLabel: formatDay(DateTime.now())),
                ),
                const SizedBox(height: 32),
                EntranceSlice(
                  begin: 0.16,
                  end: 0.72,
                  child: StudyCount(count: studies.length),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: EntranceSlice(
                    begin: 0.28,
                    end: 1,
                    child: StudyIndex(studies: studies),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
