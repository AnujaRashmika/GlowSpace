class Category {

  final String id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromFirestore(
      String id,
      Map<String, dynamic> data,
      ) {

    return Category(

      id: id,

      name: data['name'] ?? '',

      image: data['image'] ?? '',

    );
  }

}