import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';

void main() {
  testWidgets('Portfolio app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    // Splash loading finishes in ~2.5s
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pump();

    expect(find.text('ENTER PORTFOLIO'), findsOneWidget);
    await tester.tap(find.text('ENTER PORTFOLIO'));

    // Page transition + entrance animations
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.textContaining('Vivek Bisht'), findsWidgets);
    expect(find.textContaining('BUILDING APPS'), findsOneWidget);

    // Dispose pending timers (eye / splash)
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
