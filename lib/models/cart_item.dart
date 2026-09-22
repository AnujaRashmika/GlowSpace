import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.finalPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'name': product.name,
      'price': product.finalPrice,
      'imageUrl': product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, Product product) {
    return CartItem(
      product: product,
      quantity: map['quantity'] ?? 1,
    );
  }
}
