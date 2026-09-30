import 'package:flutter/widgets.dart';

import 'package:interactions/app/theme/app_colors.dart';
import 'package:interactions/app/theme/app_type.dart';

/// Shown until the first study is registered. The large 01 is decorative.
class HomeEmpty extends StatelessWidget {
  const HomeEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 8, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _GhostNumber()),
          Text('Ready when you are', style: AppType.emptyTitle),
          SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(color: AppColors.accent),
            child: SizedBox(width: 28, height: 1.5),
          ),
          SizedBox(height: 16),
          Text(
            'Each study you make will show up as a number. Tap it to step inside.',
            style: AppType.emptyBody,
          ),
        ],
      ),
    );
  }
}

class _GhostNumber extends StatelessWidget {
  const _GhostNumber();

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text('01', style: AppType.ghostNumber),
        ),
      ),
    );
  }
}
