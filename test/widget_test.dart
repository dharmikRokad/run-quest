// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_quest/presentation/screens/auth/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen displays slides and Skip button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: OnboardingScreen(),
    ));

    // Verify that the title of the first onboarding page is displayed
    expect(find.text('Welcome to Run Quest'), findsOneWidget);
    
    // Verify that the Skip button is present
    expect(find.text('Skip'), findsOneWidget);
  });
}

