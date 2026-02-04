import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_parts_app/providers/inventory_provider.dart';
// Note: We are keeping the file name add_category_screen.dart for simplicity but updating content to be "Manage Categories"

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<AddCategoryScreen> {
  final _addController = TextEditingController();

  Future<void> _addCategory() async {
    if (_addController.text.trim().isEmpty) return;
    
    await Provider.of<InventoryProvider>(context, listen: false)
        .addCategory(_addController.text.trim());
        
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category Added')));
      _addController.clear();
    }
  }

  void _showEditDialog(int id, String currentName) {
    final editController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (editController.text.trim().isNotEmpty) {
                  await Provider.of<InventoryProvider>(context, listen: false)
                      .updateCategory(id, editController.text.trim());
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category Updated')));
                    Navigator.pop(ctx);
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Category?'),
          content: const Text('This will delete the category and ALL associated parts. This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                await Provider.of<InventoryProvider>(context, listen: false).deleteCategory(id);
                if (mounted) Navigator.pop(ctx);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Categories')),
      body: Column(
        children: [
          // Add New Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addController,
                    decoration: const InputDecoration(
                      hintText: 'New Category Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addCategory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Consumer<InventoryProvider>(
              builder: (context, provider, child) {
                if (provider.categories.isEmpty) {
                  return const Center(child: Text('No categories yet.'));
                }
                
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.categories.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final cat = provider.categories[index];
                    return Card(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Icon(Icons.category, color: Theme.of(context).primaryColor, size: 20),
                        ),
                        title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditDialog(cat.id!, cat.name),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(cat.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
