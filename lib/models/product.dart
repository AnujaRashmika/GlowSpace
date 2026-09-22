class Product {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final double price;
  final double discountPrice;
  final List<String> imageUrls;
  final int stock;
  final bool featured;
  final bool active;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.discountPrice,
    required this.imageUrls,
    required this.stock,
    required this.featured,
    required this.active,
  });

  bool get hasDiscount => discountPrice > 0 && discountPrice < price;

  double get finalPrice => hasDiscount ? discountPrice : price;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((price - discountPrice) / price) * 100).round();
  }

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      categoryId: data['categoryId'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      discountPrice: (data['discountPrice'] ?? 0).toDouble(),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      stock: data['stock'] ?? 0,
      featured: data['featured'] ?? false,
      active: data['active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'price': price,
      'discountPrice': discountPrice,
      'imageUrls': imageUrls,
      'stock': stock,
      'featured': featured,
      'active': active,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? categoryId,
    double? price,
    double? discountPrice,
    List<String>? imageUrls,
    int? stock,
    bool? featured,
    bool? active,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrls: imageUrls ?? this.imageUrls,
      stock: stock ?? this.stock,
      featured: featured ?? this.featured,
      active: active ?? this.active,
    );
  }
}
