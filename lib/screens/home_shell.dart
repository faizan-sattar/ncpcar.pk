import 'package:flutter/material.dart';
import '../auth/require_signed_in.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'buy_screen.dart';
import 'sell_screen.dart';
import 'demand_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  void goTo(int i) {
    if (i == 2) {
      _goToSell();
      return;
    }
    setState(() => index = i);
  }

  Future<void> _goToSell() async {
    final ok = await ensureSignedIn(context);
    if (!ok || !mounted) return;
    setState(() => index = 2);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final screens = [
      HomeScreen(onGoToTab: goTo),
      const BuyScreen(),
      SellScreen(onPublished: () => goTo(0)),
      const DemandScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: c.paper,
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: _BottomNav(index: index, onTap: goTo),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.ashSoft)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', active: index == 0, onTap: () => onTap(0)),
              _NavItem(icon: Icons.search_rounded, label: 'Buy', active: index == 1, onTap: () => onTap(1)),
              _SellNavItem(active: index == 2, onTap: () => onTap(2)),
              _NavItem(icon: Icons.my_location_rounded, label: 'Demand', active: index == 3, onTap: () => onTap(3)),
              _NavItem(icon: Icons.person_rounded, label: 'Profile', active: index == 4, onTap: () => onTap(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = active ? c.red : c.ash;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(label, style: bodyStyle(size: 10.5, weight: 700, color: color)),
          ],
        ),
      ),
    );
  }
}

class _SellNavItem extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _SellNavItem({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -12),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: c.red,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: c.red.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 8))],
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -8),
              child: Text('Sell', style: bodyStyle(size: 10.5, weight: 700, color: active ? c.red : c.ash)),
            ),
          ],
        ),
      ),
    );
  }
}
