import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';

void main() {
  testWidgets('Chess Puzzle - Path 1: Queen deflection Qxd8+ and Rook checkmate Rxd8#', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    // Wait for boot sequence to complete
    for (int i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify initial layout has the Queen at (3, 0) and Rook at (7, 3)
    final queenSquare = find.byKey(const ValueKey("square_3_0"));
    final rookSquare = find.byKey(const ValueKey("square_7_3"));
    final targetSquare = find.byKey(const ValueKey("square_0_3"));

    expect(queenSquare, findsOneWidget);
    expect(rookSquare, findsOneWidget);
    expect(targetSquare, findsOneWidget);
    expect(find.text('20%'), findsOneWidget);

    // Step 1: Select Queen at (3, 0)
    await tester.tap(queenSquare);
    await tester.pump();

    // Step 2: Capture Black Rook at (0, 3)
    await tester.tap(targetSquare);
    await tester.pump();

    // Expect progress to update to 60%
    expect(find.text('60%'), findsOneWidget);

    // Wait 1 second for Black's automated response (Rxd8)
    await tester.pump(const Duration(seconds: 1));

    // Step 3: Select Rook at (7, 3)
    await tester.tap(rookSquare);
    await tester.pump();

    // Step 4: Capture Black Rook at (0, 3) to deliver mate
    await tester.tap(targetSquare);
    await tester.pump();

    // Expect progress to update to 100%
    expect(find.text('100%'), findsOneWidget);

    // Wait 1.5 seconds for transitions
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify access button is visible and we can enter
    final enterButton = find.text("ENTER PORTFOLIO");
    expect(enterButton, findsOneWidget);
    await tester.tap(enterButton, warnIfMissed: false);

    // Wait for screen transition
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify we are on the Home Screen
    expect(find.textContaining('Vivek Bisht'), findsWidgets);
  });

  testWidgets('Chess Puzzle - Path 2: Rook deflection Rxd8+ and Queen checkmate Qxd8#', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    // Wait for boot sequence to complete
    for (int i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    final queenSquare = find.byKey(const ValueKey("square_3_0"));
    final rookSquare = find.byKey(const ValueKey("square_7_3"));
    final targetSquare = find.byKey(const ValueKey("square_0_3"));

    expect(queenSquare, findsOneWidget);
    expect(rookSquare, findsOneWidget);
    expect(targetSquare, findsOneWidget);
    expect(find.text('20%'), findsOneWidget);

    // Step 1: Select Rook at (7, 3)
    await tester.tap(rookSquare);
    await tester.pump();

    // Step 2: Capture Black Rook at (0, 3)
    await tester.tap(targetSquare);
    await tester.pump();

    // Expect progress to update to 60%
    expect(find.text('60%'), findsOneWidget);

    // Wait 1 second for Black's automated response (Rxd8)
    await tester.pump(const Duration(seconds: 1));

    // Step 3: Select Queen at (3, 0)
    await tester.tap(queenSquare);
    await tester.pump();

    // Step 4: Capture Black Rook at (0, 3) to deliver mate
    await tester.tap(targetSquare);
    await tester.pump();

    // Expect progress to update to 100%
    expect(find.text('100%'), findsOneWidget);

    // Wait 1.5 seconds for transitions
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify access button is visible and we can enter
    final enterButton = find.text("ENTER PORTFOLIO");
    expect(enterButton, findsOneWidget);
    await tester.tap(enterButton, warnIfMissed: false);

    // Wait for screen transition
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify we are on the Home Screen
    expect(find.textContaining('Vivek Bisht'), findsWidgets);
  });
}
