import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String address;
  final String city;
  final String? note;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double total;
  final String status; // pending, confirmed, shipped, delivered, cancelled
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.address,
    required this.city,
    this.note,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      id: id,
      userId: data['userId'] ?? '',
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      customerEmail: data['customerEmail'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      note: data['note'],
      items: (data['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'address': address,
      'city': city,
      'note': note,
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
