import 'package:flutter/material.dart';
import '../auth/auth_controller.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import '../widgets/common.dart';
import 'admin/admin_shell.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

enum AuthMode { signIn, signUp }

class LoginScreen extends StatefulWidget {
  final AuthMode initialMode;
  const LoginScreen({super.key, this.initialMode = AuthMode.signIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  bool obscure = true;
  late AuthMode mode = widget.initialMode;

  bool get isSignUp => mode == AuthMode.signUp;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _switchMode(AuthMode next) {
    setState(() {
      mode = next;
      emailError = null;
      passwordError = null;
    });
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: bodyStyle(size: 13, weight: 700, color: context.colors.paper)),
        backgroundColor: context.colors.ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    );
  }

  void _continue() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    setState(() {
      emailError = _emailPattern.hasMatch(email) ? null : 'Enter a valid email address';
      passwordError = password.length < 6 ? 'Password must be at least 6 characters' : null;
    });
    if (emailError != null || passwordError != null) return;

    if (isSignUp) {
      final success = authController.register(email);
      if (!success) {
        setState(() => emailError = 'An account with this email already exists — sign in instead.');
        return;
      }
      _toast('Account created — welcome to ValleyWheels!');
      Navigator.of(context).pop(true);
      return;
    }

    if (email.toLowerCase() == AuthController.adminEmail) {
      if (!authController.signInAdmin(email, password)) {
        setState(() => emailError = 'Invalid admin credentials.');
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AdminShell()),
        (route) => false,
      );
      return;
    }

    final result = authController.signIn(email);
    switch (result) {
      case SignInResult.success:
        _toast('Welcome back!');
        Navigator.of(context).pop(true);
      case SignInResult.noAccount:
        setState(() => emailError = 'No account found for this email — sign up instead.');
      case SignInResult.banned:
        setState(() => emailError = 'This account has been suspended. Contact support.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.paper,
      body: SafeArea(
        child: ResponsiveContent(
          maxWidth: 480,
          child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Navigator.of(context).canPop())
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: IconCircleButton(icon: Icons.close_rounded, size: 36, onTap: () => Navigator.of(context).pop(false)),
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset('assets/images/logo_circle.png', fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.pill)),
                        child: Row(
                          children: [
                            Expanded(
                              child: _ModeTab(
                                key: const Key('authTab_signIn'),
                                label: 'Sign in',
                                active: mode == AuthMode.signIn,
                                onTap: () => _switchMode(AuthMode.signIn),
                              ),
                            ),
                            Expanded(
                              child: _ModeTab(
                                key: const Key('authTab_signUp'),
                                label: 'Sign up',
                                active: mode == AuthMode.signUp,
                                onTap: () => _switchMode(AuthMode.signUp),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        isSignUp ? 'Create your account' : 'Sign in to ValleyWheels',
                        style: bodyStyle(size: 24, weight: 800, color: c.ink),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isSignUp
                            ? 'New here? Create an account with your email to list, buy or request a car.'
                            : 'Welcome back — sign in with the email you registered with.',
                        style: bodyStyle(size: 13.5, color: c.inkSoft),
                      ),
                      const SizedBox(height: 26),
                      _Field(
                        label: 'Email address',
                        hint: 'you@example.com',
                        controller: emailController,
                        errorText: emailError,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _Field(
                        label: 'Password',
                        hint: 'At least 6 characters',
                        controller: passwordController,
                        errorText: passwordError,
                        obscure: obscure,
                        trailing: IconButton(
                          onPressed: () => setState(() => obscure = !obscure),
                          icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 19, color: c.ash),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.shield_outlined, size: 16, color: c.verified),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('Every car is inspection-verified before it\'s listed.',
                                style: bodyStyle(size: 12.5, color: c.inkSoft)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(label: isSignUp ? 'Create account' : 'Continue', onTap: _continue),
              const SizedBox(height: 14),
              Text(
                "By continuing you agree to ValleyWheels' Terms & Privacy Policy.",
                textAlign: TextAlign.center,
                style: bodyStyle(size: 11, color: c.ash),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ModeTab({super.key, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? c.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: active ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2))] : null,
        ),
        child: Text(label, style: bodyStyle(size: 12.5, weight: 800, color: active ? c.ink : c.ash)),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? errorText;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? trailing;
  const _Field({
    required this.label,
    required this.controller,
    this.hint,
    this.errorText,
    this.obscure = false,
    this.keyboardType,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: bodyStyle(size: 12, weight: 700, color: c.inkSoft)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: bodyStyle(size: 15, color: c.ink),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: bodyStyle(size: 15, color: c.ash),
              errorText: errorText,
              errorMaxLines: 2,
              suffixIcon: trailing,
              filled: true,
              fillColor: c.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: c.ashSoft, width: 1.4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: c.ashSoft, width: 1.4),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: c.red, width: 1.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
