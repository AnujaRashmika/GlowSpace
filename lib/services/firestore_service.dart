import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';


class FirestoreService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;


  // Get all products

  Stream<List<Product>> getProducts() {

    return _firestore
        .collection('products')
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        return Product.fromFirestore(
          doc.data(),
          doc.id,
        );

      }).toList();

    });
  }



  // Get featured products

  Stream<List<Product>> getFeaturedProducts() {

    return _firestore
        .collection('products')
        .where(
      'featured',
      isEqualTo: true,
    )
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        return Product.fromFirestore(
          doc.data(),
          doc.id,
        );

      }).toList();

    });

  }



  // Get products by category

  Stream<List<Product>> getProductsByCategory(
      String categoryId) {

    return _firestore
        .collection('products')
        .where(
      'categoryId',
      isEqualTo: categoryId,
    )
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        return Product.fromFirestore(
          doc.data(),
          doc.id,
        );

      }).toList();

    });

  }

}