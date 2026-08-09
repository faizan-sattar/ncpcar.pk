import 'package:flutter/material.dart';
import '../../auth/auth_controller.dart';
import '../../theme/app_theme.dart';
import '../../theme/responsive.dart';
import '../../widgets/common.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      top: false,
      child: ResponsiveContent(
        maxWidth: 900,
        child: ValueListenableBuilder<String?>(
        valueListenable: authController,
        builder: (context, _, _) {
          final users = authController.allAccounts;
          if (users.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_outline_rounded, size: 40, color: c.ash),
                    const SizedBox(height: 12),
                    Text('No users have registered yet', style: bodyStyle(size: 13.5, weight: 700, color: c.ink)),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            itemCount: users.length,
            itemBuilder: (context, i) {
              final user = users[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: c.ashSoft),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: c.surface2, shape: BoxShape.circle),
                      child: Icon(Icons.person_outline_rounded, size: 20, color: c.ash),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email, style: bodyStyle(size: 13, weight: 800, color: c.ink), overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text('Buyer & seller', style: bodyStyle(size: 11, color: c.ash)),
                              if (user.banned) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(color: c.amberBg, borderRadius: BorderRadius.circular(AppRadius.pill)),
                                  child: Text('Suspended', style: bodyStyle(size: 9.5, weight: 800, color: c.amber)),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    OutlineButton(
                      label: user.banned ? 'Unban' : 'Ban',
                      onTap: () => authController.setBanned(user.email, !user.banned),
                    ),
                  ],
                ),
              );
            },
          );
        },
        ),
      ),
    );
  }
}
