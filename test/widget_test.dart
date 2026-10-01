import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:interactions/app/interactions_app.dart';

void main() {
  testWidgets('Home lists the payment study', (WidgetTester tester) async {
    await tester.pumpWidget(const InteractionsApp());
    await tester.pumpAndSettle();

    expect(find.text('Interactions'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
    expect(find.text('Feedback'), findsOneWidget);
    expect(find.text('Places'), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
    expect(find.text('02'), findsOneWidget);
    expect(find.text('03'), findsOneWidget);
    expect(find.text('None yet'), findsNothing);
  });

  testWidgets('Feedback sheet follows the mood and then thanks you', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const InteractionsApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Feedback'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Give us feedback'));
    await tester.pumpAndSettle();

    expect(find.text('How was your experience?'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('mood-word'))).data,
      'Fine',
    );
    expect(find.text('Send'), findsOneWidget);

    await tester.tap(find.byKey(const Key('feedback-send')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Thanks'), findsNothing);
    expect(find.byKey(const Key('feedback-sheet')), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('mood-slider')),
      const Offset(-220, 0),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.byKey(const Key('mood-word'))).data, 'Bad');

    await tester.drag(
      find.byKey(const Key('mood-slider')),
      const Offset(360, 0),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('mood-word'))).data,
      'Great',
    );

    await tester.tap(find.byKey(const Key('feedback-send')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Thanks'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('feedback-sheet')), findsNothing);
    expect(find.text('Give us feedback'), findsOneWidget);

    await tester.tap(find.text('Give us feedback'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('feedback-close')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('feedback-sheet')), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Pay now morphs into the Plus sheet', (
    WidgetTester tester,
  ) async {
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

    expect(
      tester.getSize(find.byKey(const Key('pay-surface'))).height,
      greaterThan(300),
    );
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
