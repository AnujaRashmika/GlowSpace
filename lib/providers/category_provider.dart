import 'dart:async';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/firestore_service.dart';

class CategoryProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  StreamSubscription<List<Category>>? _sub;

  List<Category> _categories = <Category>[];
  bool _isLoading = true;

  List<Category> get categories => List<Category>.unmodifiable(_categories);
  bool get isLoading => _isLoading;

  CategoryProvider() {
    loadCategories();
  }

  void loadCategories() {
    _isLoading = true;
    notifyListeners();
    _sub?.cancel();
    _sub = _service.getCategories().listen(
      (List<Category> list) {
        _categories = List<Category>.from(list);
        _isLoading = false;
        notifyListeners();
      },
      onError: (Object _) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Category? getById(String id) {
    for (final Category category in _categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
