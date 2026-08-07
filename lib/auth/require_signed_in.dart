import 'package:flutter/material.dart';
import 'auth_controller.dart';
import '../screens/login_screen.dart';

/// Gate for actions that need an account — listing a car, contacting a
/// seller, submitting a demand request. Browsing stays open to everyone;
/// this is only called at the moment someone tries to do something.
/// Returns true once the user is signed in (either already, or just now).
Future<bool> ensureSignedIn(BuildContext context) async {
  if (authController.isSignedIn) return true;
  final result = await Navigator.of(context).push<bool>(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
  return result ?? false;
}
