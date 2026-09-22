import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class ProductProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  StreamSubscription<List<Product>>? _sub;

  List<Product> _products = <Product>[];
  bool _isLoading = true;
  String? _error;

  List<Product> get products => List<Product>.unmodifiable(_products);
  List<Product> get featuredProducts =>
      _products.where((Product p) => p.featured && p.active).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProductProvider() {
    loadProducts();
  }

  void loadProducts() {
    _isLoading = true;
    notifyListeners();
    _sub?.cancel();
    _sub = _service.getProducts().listen(
      (List<Product> list) {
        _products = list.where((Product p) => p.active).toList();
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (Object e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  List<Product> getByCategory(String categoryId) {
    return _products
        .where((Product p) => p.categoryId == categoryId)
        .toList();
  }

  Product? getById(String id) {
    for (final Product p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
