import 'package:interactions/studies/feedback/feedback_screen.dart';
import 'package:interactions/studies/payment/payment_screen.dart';
import 'package:interactions/studies/places/places_screen.dart';
import 'package:interactions/studies/study.dart';

/// The home index, in order. Append a [Study] and the next number appears.
abstract final class StudyRegistry {
  static final studies = <Study>[
    Study(
      title: 'Payment',
      note: 'Pay for Plus.',
      page: (_) => const PaymentScreen(),
    ),
    Study(
      title: 'Feedback',
      note: 'How did it feel.',
      page: (_) => const FeedbackScreen(),
    ),
    Study(
      title: 'Places',
      note: 'Open a place.',
      page: (_) => const PlacesScreen(),
    ),
  ];
}
