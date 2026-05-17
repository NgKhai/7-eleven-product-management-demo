part of product_management_app;

class CartItem {
  const CartItem(this.product, this.quantity);
  final Product product;
  final int quantity;
  double get subtotal => product.price * quantity;
}
