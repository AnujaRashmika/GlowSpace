import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  static const _guestKey = 'guest_cart_v2';
  static const _ttlMinutes = 30;

  bool _loaded = false;
  bool get isReady => _loaded;

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.total);
  bool get isEmpty => _items.isEmpty;

  CartProvider() {
    _loadGuestCart();
  }

  Future<void> _loadGuestCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_guestKey);
      if (raw == null) {
        _loaded = true;
        notifyListeners();
        return;
      }

      final map = jsonDecode(raw) as Map<String, dynamic>;
      final savedAt = DateTime.tryParse(map['savedAt']?.toString() ?? '');
      if (savedAt == null ||
          DateTime.now().difference(savedAt).inMinutes > _ttlMinutes) {
        await prefs.remove(_guestKey);
        _loaded = true;
        notifyListeners();
        return;
      }

      final list = (map['items'] as List<dynamic>? ?? []);
      _items.clear();
      for (final e in list) {
        final m = Map<String, dynamic>.from(e as Map);
        final product = Product(
          id: m['id']?.toString() ?? '',
          name: m['name']?.toString() ?? '',
          description: m['description']?.toString() ?? '',
          categoryId: m['categoryId']?.toString() ?? '',
          price: (m['price'] as num?)?.toDouble() ?? 0,
          discountPrice: (m['discountPrice'] as num?)?.toDouble() ?? 0,
          imageUrls: List<String>.from(m['imageUrls'] ?? const []),
          stock: (m['stock'] as num?)?.toInt() ?? 0,
          featured: m['featured'] == true,
          active: m['active'] != false,
        );
        if (product.id.isEmpty) continue;
        _items.add(CartItem(
          product: product,
          quantity: (m['quantity'] as num?)?.toInt() ?? 1,
        ));
      }
    } catch (_) {
      // ignore corrupt cache
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveGuestCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_items.isEmpty) {
        await prefs.remove(_guestKey);
        return;
      }
      final data = {
        'savedAt': DateTime.now().toIso8601String(),
        'items': _items
            .map((i) => {
                  'id': i.product.id,
                  'name': i.product.name,
                  'description': i.product.description,
                  'categoryId': i.product.categoryId,
                  'price': i.product.price,
                  'discountPrice': i.product.discountPrice,
                  'imageUrls': i.product.imageUrls,
                  'stock': i.product.stock,
                  'featured': i.product.featured,
                  'active': i.product.active,
                  'quantity': i.quantity,
                })
            .toList(),
      };
      await prefs.setString(_guestKey, jsonEncode(data));
    } catch (_) {}
  }

  void addToCart(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    _saveGuestCart();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    _saveGuestCart();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      _saveGuestCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveGuestCart();
    notifyListeners();
  }

  void mergeGuestCart() {
    _saveGuestCart();
    notifyListeners();
  }

  bool contains(String productId) {
    return _items.any((i) => i.product.id == productId);
  }
}
