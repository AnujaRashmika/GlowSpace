import 'package:flutter/material.dart';

import '../models/banner_model.dart';
import '../services/firestore_service.dart';

class BannerProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<BannerModel> _banners = [];

  List<BannerModel> get banners => _banners;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void loadBanners() {
    _isLoading = true;
    notifyListeners();

    _service.getBanners().listen((data) {
      _banners = data;
      _isLoading = false;
      notifyListeners();
    });
  }
}