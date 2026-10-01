import 'package:interactions/studies/feedback/copy/feedback_copy.dart';

/// The only three answers. The slider is continuous; the word is one of these.
enum Mood {
  bad,
  fine,
  great;

  String get label => switch (this) {
    Mood.bad => FeedbackCopy.bad,
    Mood.fine => FeedbackCopy.fine,
    Mood.great => FeedbackCopy.great,
  };

  /// Where this mood rests on the slider, from Bad at 0 to Great at 1.
  double get anchor => switch (this) {
    Mood.bad => 0,
    Mood.fine => 0.5,
    Mood.great => 1,
  };

  Mood? get towardGreat => switch (this) {
    Mood.bad => Mood.fine,
    Mood.fine => Mood.great,
    Mood.great => null,
  };

  Mood? get towardBad => switch (this) {
    Mood.bad => null,
    Mood.fine => Mood.bad,
    Mood.great => Mood.fine,
  };
}

/// The word changes at a quarter and three quarters of the travel.
Mood moodAt(double t) {
  if (t < 0.25) return Mood.bad;
  if (t < 0.75) return Mood.fine;
  return Mood.great;
}

/// The stop a released thumb should land on when there is no flick.
Mood nearestMood(double t) => moodAt(t);
