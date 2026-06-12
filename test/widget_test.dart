// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:run_quest/main.dart';

void main() {
  testWidgets('Design system showcase smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RunQuestApp());

    // Verify that our showcase screen title is displayed.
    expect(find.text('RUN QUEST DESIGN SYSTEM'), findsOneWidget);
  });
}

