import 'package:flutter/foundation.dart';

enum ReportStatus { open, resolved, dismissed }

class AdminReport {
  final int id;
  final String subject;
  final String reason;
  final String reportedBy;
  final ReportStatus status;

  const AdminReport({
    required this.id,
    required this.subject,
    required this.reason,
    required this.reportedBy,
    this.status = ReportStatus.open,
  });

  AdminReport copyWith({ReportStatus? status}) =>
      AdminReport(id: id, subject: subject, reason: reason, reportedBy: reportedBy, status: status ?? this.status);
}

const _seedReports = [
  AdminReport(
    id: 1,
    subject: 'Toyota Yaris ATIV X — Karachi',
    reason: 'Price looks unusually low for the listed mileage — possible mistake or scam.',
    reportedBy: 'buyer_report@ncpcar.pk',
  ),
  AdminReport(
    id: 2,
    subject: 'Seller: seller@example.com',
    reason: 'Not responding to chat messages after 3 days.',
    reportedBy: 'concerned_buyer@ncpcar.pk',
  ),
];

/// Flags raised against listings or sellers, for the admin panel to triage.
/// Seeded with a couple of illustrative examples since there's no in-app
/// "report this" action yet for buyers to generate real ones.
class ReportsStore extends ValueNotifier<List<AdminReport>> {
  ReportsStore() : super(List.unmodifiable(_seedReports));

  void setStatus(int id, ReportStatus status) {
    value = List.unmodifiable(value.map((r) => r.id == id ? r.copyWith(status: status) : r));
  }
}

final reportsStore = ReportsStore();
