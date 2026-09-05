import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';

void main() {
  testWidgets('Portfolio app loads and navigates to home', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    // Pump through splash screen progress (2.5s) + transition delay (0.5s)
    await tester.pump(const Duration(milliseconds: 3200));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.textContaining('Vivek Bisht'), findsWidgets);

    // Dispose pending timers / widgets
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}


