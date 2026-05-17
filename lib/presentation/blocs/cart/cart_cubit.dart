part of product_management_app;

class CartState {
  const CartState(this.items);
  final List<CartItem> items;
  int get count => items.fold(0, (sum, item) => sum + item.quantity);
  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState([]));

  void add(Product product) {
    final existing = state.items.where((item) => item.product.id == product.id).firstOrNull;
    if (existing == null) {
      emit(CartState([...state.items, CartItem(product, 1)]));
    } else {
      emit(CartState(state.items.map((item) {
        if (item.product.id != product.id) return item;
        return CartItem(item.product, item.quantity + 1);
      }).toList()));
    }
  }

  void decrement(Product product) {
    final updated = <CartItem>[];
    for (final item in state.items) {
      if (item.product.id != product.id) {
        updated.add(item);
      } else if (item.quantity > 1) {
        updated.add(CartItem(item.product, item.quantity - 1));
      }
    }
    emit(CartState(updated));
  }

  void remove(Product product) {
    emit(CartState(state.items.where((item) => item.product.id != product.id).toList()));
  }

  void clear() => emit(const CartState([]));
}
