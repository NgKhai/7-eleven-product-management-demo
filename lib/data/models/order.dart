part of product_management_app;

class OrderItem {
  const OrderItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  final String productId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: (json['productId'] ?? '').toString(),
        productName: (json['productName'] ?? '').toString(),
        imageUrl: (json['imageUrl'] ?? '').toString(),
        quantity: ((json['quantity'] ?? 0) as num).toInt(),
        unitPrice: ((json['unitPrice'] ?? 0) as num).toDouble(),
        subtotal: ((json['subtotal'] ?? 0) as num).toDouble(),
      );
}

class Order {
  const Order({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerEmail,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.note,
    required this.createdAt,
  });

  final String id;
  final String orderNumber;
  final String customerName;
  final String customerEmail;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String note;
  final DateTime createdAt;

  factory Order.fromJson(Map<String, dynamic> json) {
    final customer = json['customerId'];
    return Order(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      orderNumber: (json['orderNumber'] ?? '').toString(),
      customerName: customer is Map ? (customer['name'] ?? '').toString() : '',
      customerEmail: customer is Map ? (customer['email'] ?? '').toString() : '',
      items: ((json['items'] ?? []) as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: ((json['totalAmount'] ?? 0) as num).toDouble(),
      status: (json['status'] ?? 'pending').toString(),
      shippingAddress: (json['shippingAddress'] ?? '').toString(),
      note: (json['note'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }
}
