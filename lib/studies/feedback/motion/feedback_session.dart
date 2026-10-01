import 'package:flutter/widgets.dart';

import 'package:interactions/studies/feedback/motion/mood_track.dart';
import 'package:interactions/studies/feedback/motion/sheet_rise.dart';

/// Wires the sheet and the mood together. The screen only hosts this.
class FeedbackSession extends ChangeNotifier {
  FeedbackSession({required TickerProvider vsync}) {
    rise = SheetRise(vsync: vsync)..addListener(_onRise);
    mood = MoodTrack(vsync: vsync, onThanks: close);
  }

  late final SheetRise rise;
  late final MoodTrack mood;
  var _closed = true;
  var _hintArmed = false;
  var _disposed = false;

  set reduced(bool value) {
    rise.reduced = value;
    mood.reduced = value;
  }

  void open() => rise.open();

  void close() {
    mood.cancelHint();
    rise.close();
  }

  void _onRise() {
    final closed = rise.closed;
    if (rise.settled && !_hintArmed) {
      _hintArmed = true;
      mood.armHint();
    }
    if (closed) _hintArmed = false;
    if (closed == _closed) return;
    _closed = closed;
    if (closed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_disposed && rise.closed) mood.reset();
      });
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    rise.removeListener(_onRise);
    rise.dispose();
    mood.dispose();
    super.dispose();
  }
}
