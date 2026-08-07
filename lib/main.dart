import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const NcpCarApp());
}

class NcpCarApp extends StatelessWidget {
  const NcpCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'ValleyWheels',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: buildAppTheme(AppColors.light, Brightness.light),
          darkTheme: buildAppTheme(AppColors.dark, Brightness.dark),
          home: const SplashScreen(),
          builder: (context, child) {
            // This is a phone-first layout: on wide viewports (desktop/web
            // testing) keep it at a phone-like width instead of stretching
            // quick actions, cards and buttons edge-to-edge.
            final c = context.colors;
            return ColoredBox(
              color: c.ink,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
