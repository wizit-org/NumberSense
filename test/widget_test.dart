// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbersense/main.dart';
import 'package:numbersense/widgets/number_card.dart';
import 'package:numbersense/models/progress_record.dart';
import 'package:numbersense/models/user_settings.dart';
import 'package:numbersense/widgets/app_scaffold.dart';

void main() {
  testWidgets('App starts with CompareTwoNumbers', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GameScreen(
          testMode: true,
          progress: ProgressRecord(level: 1, scores: []),
          onNavigate: (_) {}, // Add mock navigation handler
          settings: UserSettings(questionsPerLevel: 3, targetCorrectAnswers: 2),
        ),
      ),
    );
    // Wait for loading spinner to disappear
    await tester.pumpAndSettle();
    // Should find two NumberCards on the screen
    expect(find.byType(NumberCard), findsNWidgets(2));
  });
}
