class BannerModel {
  final String id;
  final String image;
  final String? title;
  final String? link;
  final bool active;
  final int order;

  BannerModel({
    required this.id,
    required this.image,
    this.title,
    this.link,
    this.active = true,
    this.order = 0,
  });

  factory BannerModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BannerModel(
      id: id,
      image: data['image'] ?? data['imageUrl'] ?? '',
      title: data['title'],
      link: data['link'],
      active: data['active'] ?? true,
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'link': link,
      'active': active,
      'order': order,
    };
  }
}
