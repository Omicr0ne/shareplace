enum MyDealRole {
  seller,
  interested,
}

enum MyDealProgress {
  pending,
  sold,
}

class MyDealSummary {
  const MyDealSummary({
    required this.id,
    required this.role,
    required this.progress,
    required this.title,
    required this.description,
    required this.coverImageUrl,
    this.interestedCount = 0,
    this.counterpartPhone,
  });

  final String id;
  final MyDealRole role;
  final MyDealProgress progress;
  final String title;
  final String description;
  final String coverImageUrl;
  final int interestedCount;
  final String? counterpartPhone;
}
