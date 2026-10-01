import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:interactions/app/interactions_app.dart';

void main() {
  testWidgets('Home lists the payment study', (WidgetTester tester) async {
    await tester.pumpWidget(const InteractionsApp());
    await tester.pumpAndSettle();

    expect(find.text('Interactions'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
    expect(find.text('Feedback'), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
    expect(find.text('02'), findsOneWidget);
    expect(find.text('None yet'), findsNothing);
  });

  testWidgets('Give us feedback stays on the invitation', (WidgetTester tester) async {
    await tester.pumpWidget(const InteractionsApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Feedback'));
    await tester.pumpAndSettle();

    expect(find.text('Give us feedback'), findsOneWidget);
    expect(find.text('One honest\nnote.'), findsOneWidget);

    await tester.tap(find.text('Give us feedback'));
    await tester.pumpAndSettle();
    expect(find.text('Give us feedback'), findsOneWidget);
    expect(find.text('Bad'), findsNothing);
  });

  testWidgets('Pay now morphs into the Plus sheet', (WidgetTester tester) async {
    await tester.pumpWidget(const InteractionsApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Payment'));
    await tester.pumpAndSettle();

    expect(find.text('Pay now'), findsOneWidget);
    expect(find.text('Studio'), findsOneWidget);

    await tester.tap(find.text('Pay now'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byKey(const Key('pay-surface'))).height, greaterThan(300));
    expect(find.text('Do more with Plus'), findsOneWidget);
    expect(find.text('Start yearly · \$50'), findsOneWidget);

    await tester.ensureVisible(find.text('Monthly'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Monthly'));
    await tester.pumpAndSettle();
    expect(find.text('Start monthly · \$6'), findsOneWidget);

    await tester.tap(find.byKey(const Key('pay-close')));
    await tester.pumpAndSettle();
    expect(find.text('Pay now'), findsOneWidget);
  });
}
