import 'package:flutter/material.dart';

class SearchWithFilterPage extends StatelessWidget {

  const SearchWithFilterPage({super.key});
  static const routeName = '/search-filter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recherche')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                  label: const Text('Filtre'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: 8,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, index) => ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.inventory_2_outlined),
                  ),
                  title: Text('Resultat ${index + 1}'),
                  subtitle: const Text('Element de demonstration'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
