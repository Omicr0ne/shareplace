import 'dart:typed_data';

import 'package:shareplace/features/product/domain/entities/product_item.dart';

class ProductsData {
  static final Map<int, bool> _interestByProductId = {};

  static final List<ProductItem> _products = [
    const ProductItem(
      id: 1,
      article: 'Canape vintage',
      vendeur: 'Steve',
      description: 'Canape confortable en bon etat.',
      ville: 'Lyon',
      tags: ['Maison', 'Deco'],
      images: [],
    ),
    const ProductItem(
      id: 2,
      article: 'Lampe design',
      vendeur: 'Alice',
      description: 'Lampe de chevet style scandinave.',
      ville: 'Paris',
      tags: ['Deco'],
      images: [],
    ),
    const ProductItem(
      id: 3,
      article: 'Table basse',
      vendeur: 'Bob',
      description: 'Table basse bois clair.',
      ville: 'Bordeaux',
      tags: ['Maison'],
      images: [],
    ),
    const ProductItem(
      id: 4,
      article: 'Chaise pliable',
      vendeur: 'David',
      description: 'Chaise pratique pour petit espace.',
      ville: 'Lille',
      tags: ['Maison', 'Jardin'],
      images: [],
    ),
    const ProductItem(
      id: 5,
      article: 'Miroir mural',
      vendeur: 'Eve',
      description: 'Miroir decoratif format vertical.',
      ville: 'Nantes',
      tags: ['Deco'],
      images: [],
    ),
  ];

  static int _nextId = _products.length + 1;

  static List<ProductItem> get products => List.unmodifiable(_products);

  static bool isInterested(int productId) {
    return _interestByProductId[productId] ?? false;
  }

  static bool toggleInterest(int productId) {
    final newValue = !isInterested(productId);
    _interestByProductId[productId] = newValue;
    return newValue;
  }

  static void removeProduct(int productId) {
    _products.removeWhere((product) => product.id == productId);
    _interestByProductId.remove(productId);
  }

  static void addProduct({
    required String article,
    required String vendeur,
    required String description,
    required String ville,
    required List<String> tags,
    required List<Uint8List> images,
  }) {
    final product = ProductItem(
      id: _nextId++,
      article: article,
      vendeur: vendeur,
      description: description,
      ville: ville,
      tags: List.unmodifiable(tags),
      images: List.unmodifiable(images),
    );

    _products.insert(
      0,
      product,
    );
  }
}
