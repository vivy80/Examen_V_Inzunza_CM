import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/categoria_model.dart';
import 'package:flutter_application_1/services/categoria_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _service = CategoryService();
  List<Category> categories = [];

  Future<void> loadCategories() async {
    categories = await _service.getCategories();
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    await _service.addCategory(name);
    await loadCategories();
  }

  Future<void> updateCategory(Category category) async {
    await _service.editCategory(category);
    await loadCategories();
  }

  Future<void> removeCategory(int id) async {
    await _service.deleteCategory(id);
    await loadCategories();
  }
}
