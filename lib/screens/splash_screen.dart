import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'home_shell.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(color: c.red, shape: BoxShape.circle),
                child: const Icon(Icons.verified_rounded, color: Colors.white, size: 52),
              ),
              const SizedBox(height: 22),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: displayStyle(size: 42, color: c.ink),
                  children: [
                    const TextSpan(text: 'Valley'),
                    TextSpan(text: 'Wheels', style: displayStyle(size: 42, color: c.red)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Pakistan's marketplace for verified, non-cut cars. Every listing inspected before it's yours.",
                textAlign: TextAlign.center,
                style: bodyStyle(size: 14, color: c.inkSoft, height: 1.4),
              ),
              const SizedBox(height: 36),
              PrimaryButton(
                label: 'Get Started',
                icon: Icons.arrow_forward_rounded,
                block: false,
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeShell()),
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
