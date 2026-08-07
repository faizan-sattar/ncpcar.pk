import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ncpcar_app/auth/auth_controller.dart';
import 'package:ncpcar_app/main.dart';
import 'package:ncpcar_app/screens/home_shell.dart';

/// Assumes a LoginScreen is already on top, defaulted to the Sign in tab.
/// Switches to Sign up and creates a brand-new account.
Future<void> _signUpNewAccount(WidgetTester tester, String email) async {
  await tester.tap(find.byKey(const Key('authTab_signUp')));
  await tester.pumpAndSettle();

  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), email);
  await tester.enterText(fields.at(1), 'password123');
  await tester.tap(find.text('Create account'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => authController.signOut());

  testWidgets('App launches to the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NcpCarApp());

    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Get Started opens the dashboard directly, no login required', (WidgetTester tester) async {
    await tester.pumpWidget(const NcpCarApp());

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Gilgit, Gilgit-Baltistan'), findsOneWidget);
    expect(find.text('Sign in to NCPCar'), findsNothing);
  });

  testWidgets('Signing up from Profile shows the email on the dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeShell()));

    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign up').first);
    await tester.pumpAndSettle();

    await _signUpNewAccount(tester, 'seth@example.com');

    expect(find.text('seth@example.com'), findsOneWidget);
    expect(find.text('Account verified'), findsOneWidget);
  });

  testWidgets('Signing in with an unregistered email is rejected', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeShell()));

    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign in').first);
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'nobody@example.com');
    await tester.enterText(fields.at(1), 'password123');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('No account found for this email — sign up instead.'), findsOneWidget);
  });

  testWidgets('Opening Sell without an account asks for sign-in first', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeShell()));

    await tester.tap(find.widgetWithText(InkWell, 'Sell'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to NCPCar'), findsOneWidget);

    await _signUpNewAccount(tester, 'seller@example.com');

    expect(find.text('PHOTOS (MIN. 6)'), findsOneWidget);
  });

  testWidgets('Sell flow shows only the current step, not every step at once', (WidgetTester tester) async {
    authController.register('stepper@example.com');
    await tester.pumpWidget(const MaterialApp(home: HomeShell()));

    await tester.tap(find.widgetWithText(InkWell, 'Sell'));
    await tester.pumpAndSettle();

    expect(find.text('PHOTOS (MIN. 6)'), findsOneWidget);
    expect(find.text('VEHICLE SPECS'), findsNothing);
    expect(find.text('REVIEW & PUBLISH'), findsNothing);
  });

  testWidgets('Admin credentials open the admin dashboard via the regular Sign in tab', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeShell()));

    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign in').first);
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), AuthController.adminEmail);
    await tester.enterText(fields.at(1), AuthController.adminPassword);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('NCPCar Admin'), findsOneWidget);
    expect(find.text('Registered users'), findsOneWidget);
  });

  testWidgets('Wrong admin password is rejected', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeShell()));

    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign in').first);
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), AuthController.adminEmail);
    await tester.enterText(fields.at(1), 'wrongpassword');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid admin credentials.'), findsOneWidget);
    expect(find.text('NCPCar Admin'), findsNothing);
  });
}
