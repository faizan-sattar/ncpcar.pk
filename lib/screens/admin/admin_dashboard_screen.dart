import 'package:flutter/material.dart';
import '../../auth/auth_controller.dart';
import '../../admin/reports_store.dart';
import '../../models/car_listing.dart';
import '../../theme/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  final ValueChanged<int> onGoToTab;
  const AdminDashboardScreen({super.key, required this.onGoToTab});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text('OVERVIEW', style: eyebrowStyle(c.ash)),
          const SizedBox(height: 10),
          ValueListenableBuilder<String?>(
            valueListenable: authController,
            builder: (context, _, _) {
              final users = authController.allAccounts;
              final banned = users.where((a) => a.banned).length;
              return ValueListenableBuilder<List<CarListing>>(
                valueListenable: listingsStore,
                builder: (context, listings, _) {
                  final verified = listings.where((c) => c.verified).length;
                  return ValueListenableBuilder<List<AdminReport>>(
                    valueListenable: reportsStore,
                    builder: (context, reports, _) {
                      final openReports = reports.where((r) => r.status == ReportStatus.open).length;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.people_outline_rounded,
                                  value: '${users.length}',
                                  label: 'Registered users',
                                  onTap: () => onGoToTab(1),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.block_rounded,
                                  value: '$banned',
                                  label: 'Suspended',
                                  onTap: () => onGoToTab(1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.directions_car_outlined,
                                  value: '${listings.length}',
                                  label: 'Active listings',
                                  onTap: () => onGoToTab(2),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.verified_outlined,
                                  value: '$verified',
                                  label: 'Verified cars',
                                  onTap: () => onGoToTab(2),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.flag_outlined,
                                  value: '$openReports',
                                  label: 'Open reports',
                                  highlight: openReports > 0,
                                  onTap: () => onGoToTab(3),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _StatTile(
                                  icon: Icons.storefront_outlined,
                                  value: '${listings.where((c) => c.isDealer).length}',
                                  label: 'Dealer listings',
                                  onTap: () => onGoToTab(2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          Text('QUICK ACTIONS', style: eyebrowStyle(c.ash)),
          const SizedBox(height: 10),
          _ActionRow(icon: Icons.people_outline_rounded, label: 'Manage users', onTap: () => onGoToTab(1)),
          _ActionRow(icon: Icons.directions_car_outlined, label: 'Moderate listings', onTap: () => onGoToTab(2)),
          _ActionRow(icon: Icons.flag_outlined, label: 'Review reports', onTap: () => onGoToTab(3)),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool highlight;
  final VoidCallback onTap;
  const _StatTile({required this.icon, required this.value, required this.label, this.highlight = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: highlight ? c.amber : c.ashSoft, width: highlight ? 1.6 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: highlight ? c.amber : c.red),
            const SizedBox(height: 10),
            Text(value, style: displayStyle(size: 24, color: c.ink)),
            Text(label, style: bodyStyle(size: 11, color: c.ash)),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: c.ashSoft),
          ),
          child: Row(
            children: [
              Icon(icon, size: 19, color: c.inkSoft),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: bodyStyle(size: 13.5, weight: 700, color: c.ink))),
              Icon(Icons.chevron_right_rounded, size: 18, color: c.ash),
            ],
          ),
        ),
      ),
    );
  }
}
