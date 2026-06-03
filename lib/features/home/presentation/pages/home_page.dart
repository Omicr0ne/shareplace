import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shareplace/app/app_routes.dart';
import 'package:shareplace/features/product/data/products_data.dart';
import 'package:shareplace/features/product/domain/entities/product_item.dart';
import 'package:shareplace/features/product/presentation/pages/product_buyer_details_page.dart';
import 'package:shareplace/features/product/presentation/pages/product_seller_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProductItem> get _products => ProductsData.products;

  Future<void> _openAddProductPage() async {
    final result = await Navigator.pushNamed(context, AppRoutes.addProduct);
    if (result == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _openProductDetails(ProductItem product) async {
    final page = product.vendeur == 'Moi'
        ? ProductSellerDetailsPage(product: product)
        : ProductBuyerDetailsPage(product: product);

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEF6C00), Color(0xFFFFB74D)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.home_outlined,
                      color: Color(0xFFEF6C00),
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Accueil'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.waving_hand_outlined),
              title: const Text('Bienvenue'),
              onTap: () {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(context, AppRoutes.welcome),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(context, AppRoutes.profile),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: const Text('Ajouter un produit'),
              onTap: () async {
                Navigator.pop(context);
                await _openAddProductPage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.price_change_outlined),
              title: const Text('Mes offres'),
              onTap: () async {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(context, AppRoutes.myDeals),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history_outlined),
              title: const Text('Historique des offres'),
              onTap: () async {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(context, AppRoutes.myDeals),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              onTap: () async {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.notifications,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel_outlined),
              title: const Text('Mentions légales'),
              onTap: () async {
                Navigator.pop(context);
                unawaited(
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.legalNotices,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('SharePlace'),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.person_outline),
            tooltip: 'Menu profil',
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: TextField(
                onTap: () => _showComingSoon(context),
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Rechercher un produit',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return _ProductCard(
                    product: product,
                    onTap: () => _openProductDetails(product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddProductPage,
        backgroundColor: const Color(0xFFEF6C00),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Message de page à venir.
  static void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('En développement.')),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  final ProductItem product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 44,
                    color: Color(0xFF8D6E63),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.article,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.vendeur,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
