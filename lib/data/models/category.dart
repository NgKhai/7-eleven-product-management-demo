part of product_management_app;

class Category {
  const Category({required this.id, required this.name});
  final String id;
  final String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
      );
}
