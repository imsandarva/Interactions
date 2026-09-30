import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:interactions/app/interactions_app.dart';

void main() {
  testWidgets('Home lists the payment study', (WidgetTester tester) async {
    await tester.pumpWidget(const InteractionsApp());
    await tester.pumpAndSettle();

    expect(find.text('Interactions'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
    expect(find.text('None yet'), findsNothing);
  });

  testWidgets('Pay now prints Tapped', (WidgetTester tester) async {
    final printed = <String>[];
    final previous = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) => printed.add('$message');
    try {
      await tester.pumpWidget(const InteractionsApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Payment'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pay now'));
      expect(printed, ['Tapped']);
    } finally {
      debugPrint = previous;
    }
  });
}
