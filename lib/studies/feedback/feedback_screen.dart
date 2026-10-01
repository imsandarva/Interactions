import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:interactions/studies/feedback/motion/feedback_session.dart';
import 'package:interactions/studies/feedback/sheet/sheet_host.dart';
import 'package:interactions/studies/feedback/stage/feedback_stage.dart';
import 'package:interactions/studies/feedback/theme/feedback_style.dart';

/// Study 02. The invitation, and the sheet that answers it.
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with TickerProviderStateMixin {
  late final FeedbackSession _session = FeedbackSession(vsync: this);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _session.reduced = MediaQuery.disableAnimationsOf(context);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _session,
      builder: (context, _) {
        return PopScope(
          canPop: _session.rise.closed,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _session.close();
          },
          child: Scaffold(
            backgroundColor: FeedbackColors.paper,
            body: Stack(
              children: [
                FeedbackStage(onGiveFeedback: _session.open),
                SheetHost(session: _session),
              ],
            ),
          ),
        );
      },
    );
  }
}
