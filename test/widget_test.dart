import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:colorfinity/main.dart';

void main() {
  testWidgets('App shows instructions when starting', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Colorfinity());

    // Verify that the app opens with helper text.
    expect(find.text('Welcome to Colorfinity! 👋\nScroll horizontally on colors to edit.\nDouble tap to change edit value.\nTap and hold to remove color.'), findsOneWidget);
  });

  testWidgets('Adds color when hitting add button', (WidgetTester tester) async {
    await tester.pumpWidget(Colorfinity());

    // Adds one color when tapping the add color button.
    await tester.tap(find.byType(FlatButton));
    await tester.pump();

    expect(find.byType(ColCard), findsOneWidget);
  });
}
