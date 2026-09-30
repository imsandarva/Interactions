import 'package:interactions/studies/payment/payment_screen.dart';
import 'package:interactions/studies/study.dart';

/// The home index, in order. Append a [Study] and the next number appears.
abstract final class StudyRegistry {
  static final studies = <Study>[
    Study(
      title: 'Payment',
      note: 'Pay for Plus.',
      page: (_) => const PaymentScreen(),
    ),
  ];
}
