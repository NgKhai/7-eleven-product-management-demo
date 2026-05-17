part of product_management_app;

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.categoryId,
    required this.categoryName,
    required this.images,
    required this.status,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final String categoryId;
  final String categoryName;
  final List<String> images;
  final String status;
  String get primaryImage => images.isEmpty ? '' : images.first;
  bool get inStock => stockQuantity > 0 && status == 'active';

  factory Product.fromJson(Map<String, dynamic> json) {
    final category = json['categoryId'];
    final rawImages = (json['images'] ?? json['imageUrls'] ?? []) as List<dynamic>;
    return Product(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: ((json['price'] ?? 0) as num).toDouble(),
      stockQuantity: ((json['stockQuantity'] ?? 0) as num).toInt(),
      categoryId: category is Map ? (category['_id'] ?? '').toString() : (category ?? '').toString(),
      categoryName: category is Map ? (category['name'] ?? '').toString() : '',
      images: rawImages.map((item) {
        if (item is Map) return (item['url'] ?? '').toString();
        return item.toString();
      }).where((url) => url.isNotEmpty).toList(),
      status: (json['status'] ?? 'active').toString(),
    );
  }
}
