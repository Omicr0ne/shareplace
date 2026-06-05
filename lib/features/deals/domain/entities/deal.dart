enum DealState {
  open,
  closed,
  cancelled,
}

class Deal {
  Deal({
    required this.id,
    required this.sellerProfileId,
    required this.title,
    required this.description,
    required this.postalCode,
    this.maxWinnerCount = 1,
    this.state = DealState.open,
    this.isFoodSupply = false,
    this.tags = const [],
    this.imageUrls = const [],
    this.createdAt,
    this.updatedAt,
  }) {
    _validate();
  }

  factory Deal.fromJson(Map<String, Object?> json) {
    return Deal(
      id: json['id']! as String,
      sellerProfileId: json['seller_profile_id']! as String,
      title: json['title']! as String,
      description: json['description']! as String,
      postalCode: json['postal_code']! as String,
      maxWinnerCount: json['max_winner_count'] as int? ?? 1,
      state: _dealStateFromJson(json['state'] as String? ?? 'open'),
      isFoodSupply: json['is_food_supply'] as bool? ?? false,
      tags: _tagsFromJson(json['deal_tags']),
      imageUrls: _imageUrlsFromJson(json['deal_images']),
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );
  }

  final String id;
  final String sellerProfileId;
  final String title;
  final String description;
  final String postalCode;
  final int maxWinnerCount;
  final DealState state;
  final bool isFoodSupply;
  final List<String> tags;
  final List<String> imageUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Deal copyWith({
    String? id,
    String? sellerProfileId,
    String? title,
    String? description,
    String? postalCode,
    int? maxWinnerCount,
    DealState? state,
    bool? isFoodSupply,
    List<String>? tags,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Deal(
      id: id ?? this.id,
      sellerProfileId: sellerProfileId ?? this.sellerProfileId,
      title: title ?? this.title,
      description: description ?? this.description,
      postalCode: postalCode ?? this.postalCode,
      maxWinnerCount: maxWinnerCount ?? this.maxWinnerCount,
      state: state ?? this.state,
      isFoodSupply: isFoodSupply ?? this.isFoodSupply,
      tags: tags ?? this.tags,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'seller_profile_id': sellerProfileId,
      'title': title,
      'description': description,
      'postal_code': postalCode,
      'max_winner_count': maxWinnerCount,
      'state': state.name,
      'is_food_supply': isFoodSupply,
      if (createdAt != null) 'created_at': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toUtc().toIso8601String(),
    };
  }

  void _validate() {
    if (maxWinnerCount < 1) {
      throw ArgumentError.value(
        maxWinnerCount,
        'maxWinnerCount',
        'Must be >= 1.',
      );
    }
    if (title.length < 3 || title.length > 120) {
      throw ArgumentError.value(
        title,
        'title',
        'Length must be between 3 and 120.',
      );
    }
    if (description.length < 10 || description.length > 2000) {
      throw ArgumentError.value(
        description,
        'description',
        'Length must be between 10 and 2000.',
      );
    }
  }
}

DealState _dealStateFromJson(String value) {
  return DealState.values.firstWhere((state) => state.name == value);
}

DateTime? _dateTimeFromJson(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }

  return DateTime.parse(value as String);
}

List<String> _tagsFromJson(Object? value) {
  if (value is! List) {
    return const [];
  }

  return value
      .map((item) {
        if (item is! Map) {
          return null;
        }
        final tag = item['tags'];
        if (tag is! Map || tag['state'] != 'approved') {
          return null;
        }
        return tag['label'] as String?;
      })
      .nonNulls
      .toList(growable: false);
}

List<String> _imageUrlsFromJson(Object? value) {
  if (value is! List) {
    return const [];
  }

  final rows = value.whereType<Map<String, Object?>>().toList()
    ..sort((a, b) {
      final left = (a['position'] as int?) ?? 0;
      final right = (b['position'] as int?) ?? 0;
      return left.compareTo(right);
    });

  return rows
      .map((item) => item['url'] as String?)
      .nonNulls
      .where((url) => url.isNotEmpty)
      .toList(growable: false);
}
