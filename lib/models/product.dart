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


  // Firestore -> Product Object

  factory Product.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return Product(

      id: id,

      name: data['name'] ?? '',

      description: data['description'] ?? '',

      categoryId: data['categoryId'] ?? '',


      price: (data['price'] ?? 0).toDouble(),


      discountPrice:
      (data['discountPrice'] ?? 0).toDouble(),


      imageUrls:
      List<String>.from(data['imageUrls'] ?? []),


      stock: data['stock'] ?? 0,


      featured: data['featured'] ?? false,


      active: data['active'] ?? true,

    );
  }


  // Product Object -> Firestore Map

  Map<String, dynamic> toMap() {

    return {

      "name": name,

      "description": description,

      "categoryId": categoryId,

      "price": price,

      "discountPrice": discountPrice,

      "imageUrls": imageUrls,

      "stock": stock,

      "featured": featured,

      "active": active,

    };

  }
}