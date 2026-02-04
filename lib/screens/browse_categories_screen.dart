import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_parts_app/providers/inventory_provider.dart';
import 'package:mobile_parts_app/screens/view_parts_screen.dart';

class BrowseCategoriesScreen extends StatefulWidget {
  const BrowseCategoriesScreen({super.key});

  @override
  State<BrowseCategoriesScreen> createState() => _BrowseCategoriesScreenState();
}

class _BrowseCategoriesScreenState extends State<BrowseCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventoryProvider>(context, listen: false).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse by Category')),
      body: Consumer<InventoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.categories.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final cat = provider.categories[index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.folder, color: Theme.of(context).primaryColor),
                  title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewPartsScreen(categoryId: cat.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
