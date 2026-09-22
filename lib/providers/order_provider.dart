import 'dart:async';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/firestore_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  StreamSubscription? _sub;

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  bool _isPlacing = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  bool get isPlacing => _isPlacing;
  String? get error => _error;

  void listen(String? userId) {
    _sub?.cancel();
    if (userId == null) {
      _orders = [];
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    _sub = _service.getUserOrders(userId).listen((list) {
      _orders = list;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<String?> placeOrder(OrderModel order) async {
    _isPlacing = true;
    _error = null;
    notifyListeners();
    try {
      final id = await _service.placeOrder(order);
      _isPlacing = false;
      notifyListeners();
      return id;
    } catch (e) {
      _error = e.toString();
      _isPlacing = false;
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
