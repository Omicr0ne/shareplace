class ProductItem {
  const ProductItem({
    required this.id,
    required this.article,
    required this.vendeur,
    required this.description,
    required this.ville,
    required this.tags,
  });

  final int id;
  final String article;
  final String vendeur;
  final String description;
  final String ville;
  final List<String> tags;
}
