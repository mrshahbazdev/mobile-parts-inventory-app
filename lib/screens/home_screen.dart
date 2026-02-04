import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_parts_app/providers/inventory_provider.dart';
import 'package:mobile_parts_app/screens/add_category_screen.dart';
import 'package:mobile_parts_app/screens/add_part_screen.dart';
import 'package:mobile_parts_app/screens/view_parts_screen.dart';
import 'package:mobile_parts_app/screens/browse_categories_screen.dart';
import 'package:mobile_parts_app/services/backup_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Safe data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventoryProvider>(context, listen: false).loadCategories();
      // Also load parts to show stats if needed, or create a specific stats method
      Provider.of<InventoryProvider>(context, listen: false).loadParts(); // Initial load for stats
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Parts Dashboard'),
        actions: [
          IconButton(
             icon: const Icon(Icons.refresh),
             onPressed: () {
               final prov = Provider.of<InventoryProvider>(context, listen: false);
               prov.loadCategories();
               prov.resetPartsList();
               prov.loadParts();
             },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats Section
            Consumer<InventoryProvider>(
              builder: (context, provider, child) {
                // Determine counts - simplified for demo.
                // In real app, might want a specific 'getStats' method in provider that does a lightweight DB count
                final partCount = provider.parts.length; // This is only loaded parts, ideal is DB count
                final categoryCount = provider.categories.length;
                
                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context, 
                        'Total Parts', 
                        '$partCount+', // rough indicator as acts on pagination
                        Icons.inventory_2,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context, 
                        'Categories', 
                        '$categoryCount', 
                        Icons.category,
                        Colors.orange,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            
            Text('Quick Actions', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            
            // Menu Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildActionCard(
                  context,
                  'Add Part',
                  Icons.add_circle,
                  theme.primaryColor,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPartScreen())),
                ),
                _buildActionCard(
                  context,
                  'View Inventory',
                  Icons.view_list,
                  theme.colorScheme.secondary,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewPartsScreen())),
                ),
                _buildActionCard(
                  context,
                  'Manage Categories', // Updated title
                  Icons.edit_note,
                  Colors.purple,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCategoryScreen())),
                ),
                _buildActionCard(
                  context,
                  'Browse Categories',
                  Icons.folder_open,
                  Colors.teal,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BrowseCategoriesScreen())),
                ),
                _buildActionCard(
                  context,
                  'Backup Data',
                  Icons.save_alt,
                  Colors.grey.shade700,
                  () => BackupService.backupDatabase(context),
                ),
                _buildActionCard(
                  context,
                  'Restore Backup',
                  Icons.restore,
                  Colors.redAccent,
                  () => BackupService.restoreDatabase(context),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            const Center(
              child: Text(
                'Powered by Muhammad Shahbaz',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: color.withOpacity(0.8), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
