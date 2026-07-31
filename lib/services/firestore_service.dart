import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category.dart';
import '../models/product.dart';


class FirestoreService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Get all categories

  Stream<List<Category>> getCategories() {

    return _firestore
        .collection("categories")
        .snapshots()
        .map(

          (snapshot){

        return snapshot.docs.map(

              (doc){

            return Category.fromFirestore(
              doc.id,
              doc.data(),
            );

          },

        ).toList();

      },

    );

  }

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