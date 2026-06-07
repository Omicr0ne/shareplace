enum DealTagState {
  pending,
  approved,
  rejected,
}

class DealTag {
  DealTag({
    required this.id,
    required this.label,
    String? normalizedLabel,
    this.color,
    this.state = DealTagState.pending,
    this.createdByProfileId,
    this.createdAt,
    this.updatedAt,
  }) : normalizedLabel = normalizedLabel ?? normalizeLabel(label);

  factory DealTag.fromJson(Map<String, Object?> json) {
    return DealTag(
      id: json['id']! as String,
      label: json['label']! as String,
      normalizedLabel: json['normalized_label']! as String,
      color: json['color'] as String?,
      state: _dealTagStateFromJson(json['state'] as String? ?? 'pending'),
      createdByProfileId: json['created_by_profile_id'] as String?,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
    );
  }

  final String id;
  final String label;
  final String normalizedLabel;
  final String? color;
  final DealTagState state;
  final String? createdByProfileId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'label': label,
      'normalized_label': normalizedLabel,
      if (color != null) 'color': color,
      'state': state.name,
      if (createdByProfileId != null)
        'created_by_profile_id': createdByProfileId,
      if (createdAt != null) 'created_at': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toUtc().toIso8601String(),
    };
  }

  static String normalizeLabel(String label) {
    return label.trim().toLowerCase().runes.map((rune) {
      final character = String.fromCharCode(rune);
      return _accentReplacements[character] ?? character;
    }).join();
  }
}

const _accentReplacements = <String, String>{
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'ä': 'a',
  'ã': 'a',
  'å': 'a',
  'ç': 'c',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'ñ': 'n',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'ö': 'o',
  'õ': 'o',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ü': 'u',
  'ý': 'y',
  'ÿ': 'y',
};

DealTagState _dealTagStateFromJson(String value) {
  return DealTagState.values.firstWhere((state) => state.name == value);
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
