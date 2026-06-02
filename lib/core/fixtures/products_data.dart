class ProductItem {
	const ProductItem({
		required this.article,
		required this.vendeur,
		required this.description,
		required this.ville,
		required this.tags,
	});

	final String article;
	final String vendeur;
	final String description;
	final String ville;
	final List<String> tags;
}

class ProductsData {
	static final List<ProductItem> _products = [
		const ProductItem(
			article: 'Canape vintage',
			vendeur: 'Steve',
			description: 'Canape confortable en bon etat.',
			ville: 'Lyon',
			tags: ['Maison', 'Deco'],
		),
		const ProductItem(
			article: 'Lampe design',
			vendeur: 'Alice',
			description: 'Lampe de chevet style scandinave.',
			ville: 'Paris',
			tags: ['Deco'],
		),
		const ProductItem(
			article: 'Table basse',
			vendeur: 'Bob',
			description: 'Table basse bois clair.',
			ville: 'Bordeaux',
			tags: ['Maison'],
		),
		const ProductItem(
			article: 'Chaise pliable',
			vendeur: 'David',
			description: 'Chaise pratique pour petit espace.',
			ville: 'Lille',
			tags: ['Maison', 'Jardin'],
		),
		const ProductItem(
			article: 'Miroir mural',
			vendeur: 'Eve',
			description: 'Miroir decoratif format vertical.',
			ville: 'Nantes',
			tags: ['Deco'],
		),
	];

	static List<ProductItem> get products => List.unmodifiable(_products);

	static void addProduct({
		required String article,
		required String vendeur,
		required String description,
		required String ville,
		required List<String> tags,
	}) {
		_products.insert(
			0,
			ProductItem(
				article: article,
				vendeur: vendeur,
				description: description,
				ville: ville,
				tags: List.unmodifiable(tags),
			),
		);
	}
}
