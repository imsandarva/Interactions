import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/motion/feedback_session.dart';
import 'package:interactions/studies/feedback/motion/feedback_spec.dart';
import 'package:interactions/studies/feedback/sheet/feedback_sheet.dart';
import 'package:interactions/studies/feedback/theme/feedback_style.dart';

/// Scrim plus the sheet. A cross-fade when motion is reduced, otherwise a rise.
class SheetHost extends StatelessWidget {
  const SheetHost({required this.session, super.key});

  final FeedbackSession session;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: session.rise,
      builder: (context, _) => _place(context),
    );
  }

  Widget _place(BuildContext context) {
    final rise = session.rise;
    if (rise.closed) return const SizedBox.shrink();
    final media = MediaQuery.of(context);
    final height = FeedbackSpec.sheetHeight(media.size.height, media.textScaler.scale(1), media.padding.bottom);
    final dy = rise.reduced ? 0.0 : (1 - rise.t) * height;
    final fade = rise.reduced ? rise.t : 1.0;
    return Stack(
      children: [
        Positioned.fill(child: _scrim(rise.t)),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: height,
          child: Transform.translate(
            offset: Offset(0, dy),
            child: Opacity(
              opacity: fade.clamp(0.0, 1.0),
              child: FeedbackSheet(
                mood: session.mood,
                rise: rise,
                onClose: session.close,
                onSend: session.mood.send,
                travel: height,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _scrim(double t) {
    return GestureDetector(
      key: const Key('feedback-scrim'),
      behavior: HitTestBehavior.opaque,
      onTap: session.close,
      child: ColoredBox(color: FeedbackColors.scrim.withValues(alpha: 0.42 * t)),
    );
  }
}
