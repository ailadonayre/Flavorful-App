import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flavorful/main.dart';

void main() {
  testWidgets('App launches and shows Flavorful title',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(FlavorfulApp());

    // Verify that the AppBar title is present.
    expect(find.text('Flavorful'), findsOneWidget);

    // Verify that at least one recipe title is displayed on screen.
    expect(find.byType(ListView), findsOneWidget);
  });
}
