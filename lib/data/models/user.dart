part of product_management_app;

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone = '',
    this.address = '',
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String address;
  bool get isAdmin => role == 'admin';

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: (json['id'] ?? json['_id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        role: (json['role'] ?? 'user').toString(),
        phone: (json['phone'] ?? '').toString(),
        address: (json['address'] ?? '').toString(),
      );
}
