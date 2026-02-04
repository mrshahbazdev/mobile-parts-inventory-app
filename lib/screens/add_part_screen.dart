import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_parts_app/models/part_model.dart';
import 'package:mobile_parts_app/models/category_model.dart';
import 'package:mobile_parts_app/providers/inventory_provider.dart';

class AddPartScreen extends StatefulWidget {
  final PartModel? partToEdit;
  const AddPartScreen({super.key, this.partToEdit});

  @override
  State<AddPartScreen> createState() => _AddPartScreenState();
}

class _AddPartScreenState extends State<AddPartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();
  
  int? _selectedCategoryId;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill if editing
    if (widget.partToEdit != null) {
      _isEditing = true;
      _nameController.text = widget.partToEdit!.name;
      _descController.text = widget.partToEdit!.description ?? '';
      _priceController.text = widget.partToEdit!.price.toString();
      _qtyController.text = widget.partToEdit!.quantity.toString();
      _selectedCategoryId = widget.partToEdit!.categoryId;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventoryProvider>(context, listen: false).loadCategories();
    });
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final part = PartModel(
        id: _isEditing ? widget.partToEdit!.id : null, // ID needed for update
        categoryId: _selectedCategoryId!,
        name: _nameController.text,
        description: _descController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        quantity: int.tryParse(_qtyController.text) ?? 0,
      );

      final provider = Provider.of<InventoryProvider>(context, listen: false);

      if (_isEditing) {
        await provider.updatePart(part);
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Part Updated Successfully')));
           Navigator.pop(context); // Return after edit
        }
      } else {
        await provider.addPart(part);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Part Added Successfully')));
          _clearForm();
        }
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    _qtyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Part' : 'Add New Part')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<InventoryProvider>(
                  builder: (context, provider, child) {
                    return DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      hint: const Text('Select Category'),
                      items: provider.categories.map((CategoryModel cat) {
                        return DropdownMenuItem<int>(
                          value: cat.id,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCategoryId = val;
                        });
                      },
                      validator: (value) => value == null ? 'Required' : null,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder()
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Part Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description / Details'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _qtyController,
                        decoration: const InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _save,
                  child: Text(_isEditing ? 'Update Part' : 'Save Part'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
