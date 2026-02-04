import 'package:flutter/material.dart';
import 'package:mobile_parts_app/db/database_helper.dart';
import 'package:mobile_parts_app/models/category_model.dart';
import 'package:mobile_parts_app/models/part_model.dart';

class InventoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<PartModel> _parts = [];
  bool _isLoading = false;
  
  // Pagination State
  int _page = 0;
  final int _limit = 20;
  bool _hasMore = true;
  String _searchQuery = '';
  int? _selectedCategoryId;

  List<CategoryModel> get categories => _categories;
  List<PartModel> get parts => _parts;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await DatabaseHelper.instance.readAllCategories();
    } catch (e) {
      debugPrint("Error loading categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(String name) async {
    final newCategory = CategoryModel(name: name);
    await DatabaseHelper.instance.createCategory(newCategory);
    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await DatabaseHelper.instance.deleteCategory(id);
    await loadCategories();
  }
  
  Future<void> updateCategory(int id, String newName) async {
    final updatedCategory = CategoryModel(id: id, name: newName);
    await DatabaseHelper.instance.updateCategory(updatedCategory);
    await loadCategories();
  }


  // Parts Logic
  void resetPartsList() {
    _parts = [];
    _page = 0;
    _hasMore = true;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    resetPartsList();
    loadParts();
  }

  void setCategoryFilter(int? categoryId) {
    _selectedCategoryId = categoryId;
    resetPartsList();
    loadParts();
  }

  Future<void> loadParts() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final newParts = await DatabaseHelper.instance.readAllParts(
        query: _searchQuery,
        categoryId: _selectedCategoryId,
        limit: _limit,
        offset: _page * _limit,
      );

      if (newParts.length < _limit) {
        _hasMore = false;
      }

      _parts.addAll(newParts);
      _page++;
    } catch (e) {
      debugPrint("Error loading parts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPart(PartModel part) async {
    await DatabaseHelper.instance.createPart(part);
    // Refresh list if needed, or just append locally if fitting filters
    resetPartsList();
    loadParts();
  }

  Future<void> updatePart(PartModel part) async {
    await DatabaseHelper.instance.updatePart(part);
    
    // Update locally
    final index = _parts.indexWhere((p) => p.id == part.id);
    if (index != -1) {
      _parts[index] = part;
      notifyListeners();
    }
  }

  Future<void> deletePart(int id) async {
    await DatabaseHelper.instance.deletePart(id);
    _parts.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
