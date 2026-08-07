import 'package:flutter/material.dart';

/// App-wide light/dark override, independent of the OS setting — mirrors the
/// theme toggle in the web prototype (top bar + Profile > Dark mode switch).
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.dark);

  bool isDark(BuildContext context) {
    if (value == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return value == ThemeMode.dark;
  }

  void toggle(BuildContext context) {
    value = isDark(context) ? ThemeMode.light : ThemeMode.dark;
  }

  void set(bool dark) {
    value = dark ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeController = ThemeController();
