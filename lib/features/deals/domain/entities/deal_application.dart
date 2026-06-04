enum DealApplicationStatus {
  pending,
  accepted,
  rejected,
  cancelled,
}

class DealApplicationRecord {
  const DealApplicationRecord({
    required this.id,
    required this.dealId,
    required this.applicantProfileId,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String dealId;
  final String applicantProfileId;
  final DealApplicationStatus status;
  final DateTime createdAt;
}
