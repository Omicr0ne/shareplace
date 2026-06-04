import 'dart:typed_data';

class ProductItem {
  const ProductItem({
    required this.id,
    required this.sellerProfileId,
    required this.article,
    required this.vendeur,
    required this.description,
    required this.ville,
    required this.tags,
    required this.images,
  });

  final String id;
  final String sellerProfileId;
  final String article;
  final String vendeur;
  final String description;
  final String ville;
  final List<String> tags;
  final List<Uint8List> images;
}
