class BannerModel {
  final String id;
  final String image;
  final bool active;

  BannerModel({
    required this.id,
    required this.image,
    required this.active,
  });

  factory BannerModel.fromFirestore(
      Map<String, dynamic> data,
      String id) {
    return BannerModel(
      id: id,
      image: data['image'] ?? '',
      active: data['active'] ?? true,
    );
  }
}