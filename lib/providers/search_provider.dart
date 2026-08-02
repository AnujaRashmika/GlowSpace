import 'dart:async';

import 'package:flutter/material.dart';

import '../models/product.dart';

class SearchProvider extends ChangeNotifier {

  List<Product> _allProducts = [];
  List<Product> _suggestions = [];

  List<Product> get suggestions => _suggestions;

  Timer? _debounce;

  /// Product list එක ProductProvider එකෙන් inject කරනවා
  void setProducts(List<Product> products) {
    _allProducts = products;
  }

  void searchSuggestions(String query) {

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(
      const Duration(milliseconds: 250),
          () {

        if(query.trim().isEmpty){

          _suggestions = [];

        }else{

          _suggestions = _allProducts.where((product){

            return product.name
                .toLowerCase()
                .contains(query.toLowerCase());

          }).take(10).toList();

        }

        notifyListeners();

      },
    );

  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

}