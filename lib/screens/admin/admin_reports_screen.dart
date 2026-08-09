import 'package:flutter/material.dart';
import '../../admin/reports_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      top: false,
      child: ValueListenableBuilder<List<AdminReport>>(
        valueListenable: reportsStore,
        builder: (context, reports, _) {
          if (reports.isEmpty) {
            return Center(
              child: Text('No reports have been raised', style: bodyStyle(size: 13.5, weight: 700, color: c.ink)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            itemCount: reports.length,
            itemBuilder: (context, i) {
              final report = reports[i];
              final open = report.status == ReportStatus.open;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: open ? c.amber : c.ashSoft, width: open ? 1.4 : 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(report.subject, style: bodyStyle(size: 13.5, weight: 800, color: c.ink))),
                        _StatusPill(status: report.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(report.reason, style: bodyStyle(size: 12.5, color: c.inkSoft, height: 1.4)),
                    const SizedBox(height: 6),
                    Text('Reported by ${report.reportedBy}', style: bodyStyle(size: 11, color: c.ash)),
                    if (open) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GhostButton(
                              label: 'Dismiss',
                              onTap: () => reportsStore.setStatus(report.id, ReportStatus.dismissed),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Resolve',
                              onTap: () => reportsStore.setStatus(report.id, ReportStatus.resolved),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final ReportStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (label, bg, fg) = switch (status) {
      ReportStatus.open => ('Open', c.amberBg, c.amber),
      ReportStatus.resolved => ('Resolved', c.verifiedBg, c.verified),
      ReportStatus.dismissed => ('Dismissed', c.surface2, c.ash),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(label, style: bodyStyle(size: 10, weight: 800, color: fg)),
    );
  }
}
