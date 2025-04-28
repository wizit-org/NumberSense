import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:numbersense/widgets/number_card.dart';

void main() {
  testWidgets('NumberCard golden test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Center(child: NumberCard(value: 42, onTap: () {}))),
    );
    await expectLater(
      find.byType(NumberCard),
      matchesGoldenFile('goldens/number_card_42.png'),
    );
  });
}
