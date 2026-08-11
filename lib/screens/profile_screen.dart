import 'package:flutter/material.dart';
import '../auth/auth_controller.dart';
import '../auth/require_signed_in.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import '../widgets/common.dart';
import 'become_dealer_screen.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _toast(BuildContext context, String message) {
    final c = context.colors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: bodyStyle(size: 13, weight: 700, color: c.paper)),
        backgroundColor: c.ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    );
  }

  Future<void> _openMenuItem(BuildContext context, String label) async {
    if (!await ensureSignedIn(context)) return;
    if (!context.mounted) return;
    _toast(context, '$label — coming soon');
  }

  Future<void> _openBecomeDealer(BuildContext context) async {
    if (!await ensureSignedIn(context)) return;
    if (!context.mounted) return;
    if (authController.currentAccount?.isDealer ?? false) {
      _toast(context, 'You\'re already a ValleyWheels dealer');
      return;
    }
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BecomeDealerScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      child: ValueListenableBuilder<String?>(
        valueListenable: authController,
        builder: (context, email, _) {
          final signedIn = email != null;
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Align(alignment: Alignment.centerLeft, child: Text('Profile', style: bodyStyle(size: 18, weight: 800, color: c.ink))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(color: c.surface2, shape: BoxShape.circle),
                      child: Icon(Icons.person_outline_rounded, size: 30, color: c.ash),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            signedIn ? email : 'Not signed in',
                            style: signedIn ? bodyStyle(size: 15, weight: 800, color: c.ink) : bodyStyle(size: 16, weight: 800, color: c.ink),
                          ),
                          const SizedBox(height: 6),
                          if (signedIn)
                            const SealBadge(label: 'Account verified')
                          else
                            Text('Sign in or create an account to list, buy or track your cars', style: bodyStyle(size: 11.5, color: c.ash)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!signedIn)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Row(
                    children: [
                      GhostButton(
                        label: 'Sign in',
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => const LoginScreen(initialMode: AuthMode.signIn))),
                      ),
                      const SizedBox(width: 10),
                      PrimaryButton(
                        label: 'Sign up',
                        block: false,
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => const LoginScreen(initialMode: AuthMode.signUp))),
                      ),
                    ],
                  ),
                ),
              if (signedIn)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: _StatCard(value: '3', label: 'Listings')),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(value: '12', label: 'Favorites')),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(value: '4.9', label: 'Rating')),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: c.ashSoft),
                  ),
                  child: Column(
                    children: [
                      _MenuRow(icon: Icons.directions_car_outlined, label: 'My listings', onTap: () => _openMenuItem(context, 'My listings')),
                      _MenuRow(icon: Icons.favorite_border_rounded, label: 'Favorites', onTap: () => _openMenuItem(context, 'Favorites')),
                      _MenuRow(icon: Icons.chat_bubble_outline_rounded, label: 'Messages', onTap: () => _openMenuItem(context, 'Messages')),
                      _MenuRow(icon: Icons.notifications_none_rounded, label: 'Notifications', onTap: () => _openMenuItem(context, 'Notifications')),
                      _MenuRow(icon: Icons.star_border_rounded, label: 'Reviews', onTap: () => _openMenuItem(context, 'Reviews')),
                      _DarkModeRow(),
                      if (signedIn)
                        _MenuRow(
                          icon: Icons.logout_rounded,
                          label: 'Log out',
                          showChevron: false,
                          last: true,
                          onTap: () {
                            authController.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const SplashScreen()),
                              (route) => false,
                            );
                          },
                        )
                      else
                        _MenuRow(
                          icon: Icons.login_rounded,
                          label: 'Sign in',
                          showChevron: false,
                          last: true,
                          onTap: () => ensureSignedIn(context),
                        ),
                    ],
                  ),
                ),
              ),
              Builder(builder: (_) {
                final isDealer = authController.currentAccount?.isDealer ?? false;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    onTap: () => _openBecomeDealer(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [c.ink, Color.lerp(c.ink, c.surface2, 0.4)!]),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.storefront_outlined, size: 30, color: c.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isDealer ? 'You\'re a ValleyWheels dealer' : 'Become a dealer',
                                  style: bodyStyle(size: 14, weight: 800, color: Colors.white),
                                ),
                                Text(
                                  isDealer
                                      ? '${authController.currentAccount!.dealerBusinessName} · ${authController.currentAccount!.dealerCity}'
                                      : 'List in bulk, get a storefront & priority placement.',
                                  style: bodyStyle(size: 11.5, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          if (!isDealer) Icon(Icons.chevron_right_rounded, size: 18, color: Colors.white70),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 18, 30, 4),
                child: Text(
                  "ValleyWheels v1.0 · Made for buyers & sellers who don't compromise",
                  textAlign: TextAlign.center,
                  style: bodyStyle(size: 10.5, color: c.ash),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: c.ashSoft),
      ),
      child: Column(
        children: [
          Text(value, style: displayStyle(size: 22, color: c.red)),
          Text(label.toUpperCase(), style: eyebrowStyle(c.ash).copyWith(fontSize: 9.5)),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showChevron;
  final bool last;
  final VoidCallback? onTap;
  const _MenuRow({required this.icon, required this.label, this.showChevron = true, this.last = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(border: last ? null : Border(bottom: BorderSide(color: c.ashSoft))),
        child: Row(
          children: [
            Icon(icon, size: 19, color: c.inkSoft),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: bodyStyle(size: 13.5, weight: 700, color: c.ink))),
            if (showChevron) Icon(Icons.chevron_right_rounded, size: 18, color: c.ash),
          ],
        ),
      ),
    );
  }
}

class _DarkModeRow extends StatefulWidget {
  @override
  State<_DarkModeRow> createState() => _DarkModeRowState();
}

class _DarkModeRowState extends State<_DarkModeRow> {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.ashSoft))),
      child: Row(
        children: [
          Icon(Icons.dark_mode_outlined, size: 19, color: c.inkSoft),
          const SizedBox(width: 12),
          Expanded(child: Text('Dark mode', style: bodyStyle(size: 13.5, weight: 700, color: c.ink))),
          AppSwitch(
            value: themeController.isDark(context),
            onChanged: (v) => setState(() => themeController.set(v)),
          ),
        ],
      ),
    );
  }
}
