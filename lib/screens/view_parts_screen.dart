import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_parts_app/providers/inventory_provider.dart';
import 'package:mobile_parts_app/models/part_model.dart';
import 'package:mobile_parts_app/screens/add_part_screen.dart';

class ViewPartsScreen extends StatefulWidget {
  final int? categoryId;
  const ViewPartsScreen({super.key, this.categoryId});

  @override
  State<ViewPartsScreen> createState() => _ViewPartsScreenState();
}

class _ViewPartsScreenState extends State<ViewPartsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<InventoryProvider>(context, listen: false);
    provider.setCategoryFilter(widget.categoryId);
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<InventoryProvider>(context, listen: false);
      if (provider.hasMore && !provider.isLoading) {
        provider.loadParts();
      }
    }
  }

  void _showDetailDialog(PartModel part) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(part.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Price:', '${part.price}'),
              _detailRow('Quantity:', '${part.quantity}'),
              const SizedBox(height: 10),
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(part.description ?? 'N/A'),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(ctx);
                _confirmDelete(part.id!);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddPartScreen(partToEdit: part)),
                );
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
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
          title: const Text('Delete Part?'),
          content: const Text('Are you sure you want to delete this part?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                 await Provider.of<InventoryProvider>(context, listen: false).deletePart(id);
                 if (mounted) Navigator.pop(ctx);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
     );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parts Inventory'),
        actions: [
          if (widget.categoryId != null)
             IconButton(
               icon: const Icon(Icons.clear_all),
               onPressed: () {
                 // Clear filter
                 Provider.of<InventoryProvider>(context, listen: false).setCategoryFilter(null);
               },
             )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Parts',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<InventoryProvider>(context, listen: false).setSearchQuery('');
                  },
                ),
              ),
              onChanged: (value) {
                Provider.of<InventoryProvider>(context, listen: false).setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<InventoryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.parts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.parts.isEmpty) {
                  return const Center(child: Text('No parts found.'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: provider.parts.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.parts.length) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ));
                    }

                    final part = provider.parts[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Text('${part.quantity}', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                        ),
                        title: Text(part.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Price: ${part.price}'),
                        trailing: const Icon(Icons.more_vert),
                        onTap: () => _showDetailDialog(part),
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
