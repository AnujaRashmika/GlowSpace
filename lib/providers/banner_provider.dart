import 'dart:async';
import 'package:flutter/material.dart';
import '../models/banner_model.dart';
import '../services/firestore_service.dart';

class BannerProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  StreamSubscription<List<BannerModel>>? _sub;

  List<BannerModel> _banners = <BannerModel>[];
  bool _isLoading = true;

  List<BannerModel> get banners => List<BannerModel>.unmodifiable(_banners);
  bool get isLoading => _isLoading;

  BannerProvider() {
    loadBanners();
  }

  void loadBanners() {
    _isLoading = true;
    notifyListeners();
    _sub?.cancel();
    _sub = _service.getBanners().listen(
      (List<BannerModel> list) {
        _banners = List<BannerModel>.from(list);
        _isLoading = false;
        notifyListeners();
      },
      onError: (Object _) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
