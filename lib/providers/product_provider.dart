import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class ProductProvider extends ChangeNotifier {

  final FirestoreService _service = FirestoreService();
  List<Product> _products = [];
  List<Product> get products => _products;
  bool isLoading = true;

  List<Product> searchResult(String query) {

    if (query.trim().isEmpty) {
      return _products;
    }

    return _products.where((product) {

      return product.name
          .toLowerCase()
          .contains(query.toLowerCase()) ||

          product.description
              .toLowerCase()
              .contains(query.toLowerCase());

    }).toList();

  }

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      _products = await _service.getProducts().first;
      isLoading = false;
      notifyListeners();
    } catch (error) {
      debugPrint("Firestore Error: $error");
      isLoading = false;
      notifyListeners();
    }
  }

  List<Product> get featuredProducts {

    return _products
        .where((product) => product.featured)
        .toList();
  }
}