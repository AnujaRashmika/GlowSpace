import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/banner_model.dart';
import '../models/category.dart';
import '../models/order_model.dart';
import '../models/product.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Banners ───────────────────────────────────────────────
  Stream<List<BannerModel>> getBanners() {
    return _db
        .collection('banners')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snap) {
      final list = snap.docs
          .map((d) => BannerModel.fromFirestore(d.data(), d.id))
          .toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    });
  }

  // ─── Categories ────────────────────────────────────────────
  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map((snap) {
      final list = snap.docs
          .map((d) => Category.fromFirestore(d.id, d.data()))
          .toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    });
  }

  // ─── Products ──────────────────────────────────────────────
  Stream<List<Product>> getProducts() {
    return _db
        .collection('products')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Product.fromFirestore(d.data(), d.id))
            .toList());
  }

  Stream<List<Product>> getFeaturedProducts() {
    return _db
        .collection('products')
        .where('featured', isEqualTo: true)
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Product.fromFirestore(d.data(), d.id))
            .toList());
  }

  Stream<List<Product>> getProductsByCategory(String categoryId) {
    return _db
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Product.fromFirestore(d.data(), d.id))
            .toList());
  }

  Future<Product?> getProductById(String id) async {
    final doc = await _db.collection('products').doc(id).get();
    if (!doc.exists) return null;
    return Product.fromFirestore(doc.data()!, doc.id);
  }

  // ─── Users ─────────────────────────────────────────────────
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc.data()!, doc.id);
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toMap());
  }

  // ─── Orders ────────────────────────────────────────────────
  Future<String> placeOrder(OrderModel order) async {
    final ref = await _db.collection('orders').add(order.toMap());
    return ref.id;
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OrderModel.fromFirestore(d.data(), d.id))
            .toList());
  }

  Future<OrderModel?> getOrderById(String id) async {
    final doc = await _db.collection('orders').doc(id).get();
    if (!doc.exists) return null;
    return OrderModel.fromFirestore(doc.data()!, doc.id);
  }

  // ─── Wishlist ──────────────────────────────────────────────
  Stream<List<String>> getWishlistIds(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toList());
  }

  Future<void> addToWishlist(String userId, String productId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productId)
        .set({'addedAt': FieldValue.serverTimestamp()});
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productId)
        .delete();
  }

  Future<bool> isInWishlist(String userId, String productId) async {
    final doc = await _db
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productId)
        .get();
    return doc.exists;
  }
}
