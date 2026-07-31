import 'package:flutter/material.dart';

import '../models/category.dart';
import '../services/firestore_service.dart';

class CategoryProvider extends ChangeNotifier {

  final FirestoreService _service = FirestoreService();

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  bool isLoading = true;

  void loadCategories() {

    isLoading = true;
    notifyListeners();

    _service.getCategories().listen((data) {

      _categories = data;

      isLoading = false;

      notifyListeners();

    });

  }

}