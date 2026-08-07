import 'package:flutter/material.dart';
import '../../auth/auth_controller.dart';
import '../../theme/app_theme.dart';
import '../splash_screen.dart';
import 'admin_dashboard_screen.dart';
import 'admin_users_screen.dart';
import 'admin_listings_screen.dart';
import 'admin_reports_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int index = 0;

  void goTo(int i) => setState(() => index = i);

  void _logOut() {
    authController.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final screens = [
      AdminDashboardScreen(onGoToTab: goTo),
      const AdminUsersScreen(),
      const AdminListingsScreen(),
      const AdminReportsScreen(),
    ];
    return Scaffold(
      backgroundColor: c.paper,
      appBar: AppBar(
        backgroundColor: c.ink,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            ClipOval(
              child: Image.asset('assets/images/logo_circle.png', width: 22, height: 22, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
            Text('ValleyWheels Admin', style: bodyStyle(size: 15, weight: 800, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout_rounded, size: 20), onPressed: _logOut),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: _AdminNav(index: index, onTap: goTo),
    );
  }
}

class _AdminNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const _AdminNav({required this.index, required this.onTap});

  static const _items = [
    (Icons.dashboard_outlined, 'Dashboard'),
    (Icons.people_outline_rounded, 'Users'),
    (Icons.directions_car_outlined, 'Listings'),
    (Icons.flag_outlined, 'Reports'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(color: c.surface, border: Border(top: BorderSide(color: c.ashSoft))),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (i) {
              final (icon, label) = _items[i];
              final active = i == index;
              final color = active ? c.red : c.ash;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 21, color: color),
                      const SizedBox(height: 3),
                      Text(label, style: bodyStyle(size: 10, weight: 700, color: color)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
