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
        );
      },
    );
  }
}
