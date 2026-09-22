import 'dart:async';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class WishlistProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  StreamSubscription? _sub;

  Set<String> _ids = {};
  bool _isLoading = false;

  Set<String> get ids => _ids;
  bool get isLoading => _isLoading;
  int get count => _ids.length;

  void listen(String? userId) {
    _sub?.cancel();
    if (userId == null) {
      _ids = {};
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    _sub = _service.getWishlistIds(userId).listen((list) {
      _ids = list.toSet();
      _isLoading = false;
      notifyListeners();
    });
  }

  bool contains(String productId) => _ids.contains(productId);

  Future<void> toggle(String userId, String productId) async {
    if (_ids.contains(productId)) {
      await _service.removeFromWishlist(userId, productId);
    } else {
      await _service.addToWishlist(userId, productId);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
