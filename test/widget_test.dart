import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';

void main() {
  testWidgets('Portfolio app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    final skipButton = find.text('SKIP INTRO >|');
    expect(skipButton, findsOneWidget);
    await tester.tap(skipButton);

    // Pump multiple frames to let the page transition and entrance animations complete
    for (int i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.textContaining('Vivek Bisht'), findsWidgets);
    expect(find.textContaining('BUILDING APPS'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
