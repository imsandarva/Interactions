import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:interactions/app/interactions_app.dart';
import 'package:interactions/studies/places/memory/place_memory.dart';
import 'package:interactions/studies/places/motion/flight_pose.dart';
import 'package:interactions/studies/places/motion/places_spec.dart';

void main() {
  test('a free drag lifts the page with the finger', () {
    const screen = Size(390, 844);

    final open = freeDrag(dx: 0, dy: 0, screen: screen);
    expect(open.bounds, Offset.zero & screen);
    expect(open.radius, 0);
    expect(open.shadow, 0);

    final lift = freeDrag(dx: 40, dy: PlacesSpec.liftTravel, screen: screen);
    expect(
      lift.bounds.height,
      closeTo(screen.height * PlacesSpec.liftScale, 0.5),
    );
    expect(
      lift.bounds.width,
      closeTo(screen.width * PlacesSpec.liftScale, 0.5),
    );
    expect(lift.radius, PlacesSpec.liftRadius);
    expect(lift.shadow, 1);
    expect(lift.bounds.center.dx, closeTo(screen.width / 2 + 40, 0.5));
    expect(PlacesSpec.stagger(0.4, 0), 0);
    expect(PlacesSpec.stagger(1, 2), 1);
  });

  testWidgets('A place card grows into the page and shrinks back', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PlaceMemory.instance.reset();
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

    await tester.tap(find.byKey(const ValueKey('place-card-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('place-save')));
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsOneWidget);
    await tester.tap(find.byKey(const Key('place-close')));
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsNothing);
    final mark = tester.widget<Opacity>(
      find.descendant(
        of: find.byKey(const ValueKey('place-mark-0')),
        matching: find.byType(Opacity),
      ),
    );
    expect(mark.opacity, 1);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
