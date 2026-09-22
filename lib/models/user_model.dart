class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? city;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.city,
    this.createdAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      address: data['address'],
      city: data['city'],
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      createdAt: createdAt,
    );
  }
}
