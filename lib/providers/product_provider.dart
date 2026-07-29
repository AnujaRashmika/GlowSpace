import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/firestore_service.dart';


class ProductProvider extends ChangeNotifier {

  final FirestoreService _service =
  FirestoreService();


  List<Product> _products = [];

  List<Product> get products => _products;



  void loadProducts() {

    _service.getProducts().listen((data){

      _products = data;

      notifyListeners();

    });

  }



  List<Product> get featuredProducts {

    return _products
        .where((product) => product.featured)
        .toList();

  }

}