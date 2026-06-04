import 'dart:typed_data';

class DealCardItem {
  const DealCardItem({
    required this.id,
    required this.sellerProfileId,
    required this.title,
    required this.sellerName,
    required this.description,
    required this.postalCode,
    required this.tags,
    required this.images,
  });

  final String id;
  final String sellerProfileId;
  final String title;
  final String sellerName;
  final String description;
  final String postalCode;
  final List<String> tags;
  final List<Uint8List> images;
}
