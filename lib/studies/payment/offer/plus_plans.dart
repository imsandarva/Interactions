import 'dart:math' as math;

/// Dummy Plus plans. Yearly is the gentle default, never a trap.
enum PayCycle { yearly, monthly }

class PayPlan {
  const PayPlan({
    required this.cycle,
    required this.name,
    required this.priceLine,
    required this.detail,
    required this.commit,
    required this.renews,
    this.badge,
  });

  final PayCycle cycle;
  final String name;
  final String priceLine;
  final String detail;
  final String commit;
  final String renews;
  final String? badge;
}

abstract final class PlusOffer {
  static const benefits = [
    'Unlimited projects',
    'Priority exports',
    'Early access to new tools',
  ];

  static List<PayPlan> plansFor(DateTime now) {
    final yearly = _addMonths(now, 12);
    final monthly = _addMonths(now, 1);
    return [
      PayPlan(
        cycle: PayCycle.yearly,
        name: 'Yearly',
        priceLine: '\$4.17 / month',
        detail: '\$50 billed yearly',
        commit: 'Start yearly · \$50',
        renews: 'Renews yearly on ${_monthDay(yearly)} · Cancel anytime',
        badge: 'Save 30%',
      ),
      PayPlan(
        cycle: PayCycle.monthly,
        name: 'Monthly',
        priceLine: '\$6 / month',
        detail: 'Billed monthly',
        commit: 'Start monthly · \$6',
        renews: 'Renews monthly on ${_monthDay(monthly)} · Cancel anytime',
      ),
    ];
  }

  static DateTime _addMonths(DateTime from, int months) {
    final year = from.year + ((from.month - 1 + months) ~/ 12);
    final month = (from.month - 1 + months) % 12 + 1;
    final day = math.min(from.day, DateTime(year, month + 1, 0).day);
    return DateTime(year, month, day);
  }

  static String _monthDay(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
