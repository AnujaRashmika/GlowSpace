import 'package:flutter/material.dart';
import '../models/product.dart';

class SearchProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _results = [];
  List<Product> _suggestions = [];
  String _query = '';
  bool _isSearching = false;

  List<Product> get results => _results;
  List<Product> get suggestions => _suggestions;
  String get query => _query;
  bool get isSearching => _isSearching;

  void setProducts(List<Product> products) {
    _allProducts = products;
  }

  void search(String query) {
    _query = query.trim();
    if (_query.isEmpty) {
      _results = [];
      _suggestions = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    final lower = _query.toLowerCase();

    _suggestions = _allProducts
        .where((p) =>
            p.name.toLowerCase().contains(lower) ||
            p.description.toLowerCase().contains(lower))
        .take(8)
        .toList();

    _results = _allProducts
        .where((p) =>
            p.name.toLowerCase().contains(lower) ||
            p.description.toLowerCase().contains(lower))
        .toList();

    notifyListeners();
  }

  void clear() {
    _query = '';
    _results = [];
    _suggestions = [];
    _isSearching = false;
    notifyListeners();
  }
}
