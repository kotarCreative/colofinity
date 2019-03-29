import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:colorfinity/main.dart';

final String welcomeText = 'Welcome to Colorfinity! 👋\nScroll horizontally on colors to edit.\nDouble tap to change edit value.\nTap and hold to remove color.';

void main() {
  testWidgets('App shows instructions when starting',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Colorfinity());

    // Verify that the app opens with welcome text.
    expect(
        find.text(
            welcomeText,),
        findsOneWidget);
  });

  testWidgets('App removes instructions when color added', (WidgetTester tester) async  {
    await tester.pumpWidget(Colorfinity());

    // Add a color
    await tester.tap(find.byType(FlatButton));
    await tester.pump();

    // Verify that the app does not show welcome text.
    expect(
        find.text(
            welcomeText),
        findsNothing);
  });

  testWidgets('Adds color when hitting add button',
      (WidgetTester tester) async {
    await tester.pumpWidget(Colorfinity());

    // Adds one color when tapping the add color button.
    await tester.tap(find.byType(FlatButton));
    await tester.pump();

    expect(find.byType(ColCard), findsOneWidget);
  });

    testWidgets('ColCard shows the correct hex value when initialized',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ColCard(0, Color(0xFF333333))));

      // Check that color value is being displayed
      expect(find.text('#333333'), findsOneWidget);
    });
}
