import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:interactions/app/interactions_app.dart';
import 'package:interactions/studies/places/motion/flight_pose.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';

void main() {
  test('a drag from the open page lifts, then lands on the card', () {
    const screen = Size(390, 844);
    const card = Rect.fromLTWH(20, 180, 350, 460);

    final open = dragPose(dy: 0, screen: screen, card: card);
    expect(open.bounds, Offset.zero & screen);
    expect(open.radius, 0);
    expect(open.layoutT, 1);

    final lift = dragPose(
      dy: PlacesSpec.liftTravel,
      screen: screen,
      card: card,
    );
    expect(
      lift.bounds.height,
      closeTo(screen.height * PlacesSpec.liftScale, 0.01),
    );
    expect(
      lift.bounds.width,
      closeTo(screen.width * PlacesSpec.liftScale, 0.01),
    );
    expect(lift.bounds.top, PlacesSpec.liftTravel);
    expect(lift.radius, PlacesSpec.liftRadius);

    final landed = dragPose(
      dy: PlacesSpec.maxTravel,
      screen: screen,
      card: card,
    );
    expect(landed.bounds, card);
    expect(landed.radius, PlacesSpec.cardRadius);
    expect(landed.layoutT, 0);
    expect(PlacesSpec.fade(0.4, PlacesSpec.bodyStart, PlacesSpec.bodyEnd), 0);
    expect(PlacesSpec.fade(1, PlacesSpec.bodyStart, PlacesSpec.bodyEnd), 1);
  });

  testWidgets('A place card grows into the page and shrinks back', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const InteractionsApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Places'));
    await tester.pumpAndSettle();

    expect(find.text('Quiet corners worth the trip'), findsOneWidget);
    final second = tester.getRect(find.byKey(const ValueKey('place-card-1')));
    expect(second.top, lessThan(844));
    expect(second.bottom, greaterThan(844));

    await tester.tap(find.byKey(const ValueKey('place-card-0')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('Save this place'), findsOneWidget);
    expect(
      find.textContaining('Morning arrives before the city'),
      findsOneWidget,
    );
    expect(
      tester.getSize(find.byKey(const Key('place-page'))).height,
      greaterThan(700),
    );

    await tester.tap(find.byKey(const Key('place-close')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Morning arrives before the city'),
      findsNothing,
    );
    expect(find.text('Quiet Hours in Kyoto'), findsOneWidget);
    expect(find.byKey(const Key('place-page')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('place-card-0')));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const Key('place-page')),
      const Offset(0, 420),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('place-page')), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
