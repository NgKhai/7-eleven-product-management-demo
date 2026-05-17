part of product_management_app;

class OrderState {
  const OrderState({this.orders = const [], this.isLoading = false, this.error, this.status});
  final List<Order> orders;
  final bool isLoading;
  final String? error;
  final String? status;
}

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this.api) : super(const OrderState());
  final ApiClient api;

  Future<void> load({required bool mine, Object? status = _unset}) async {
    final nextStatus = identical(status, _unset) ? state.status : status as String?;
    emit(OrderState(orders: state.orders, isLoading: true, status: nextStatus));
    try {
      final response = await api.get(mine ? '/orders/my' : '/orders', {
        'status': nextStatus,
        'limit': 50,
      });
      final orders = ((response['data'] ?? []) as List<dynamic>)
          .map((item) => Order.fromJson(item as Map<String, dynamic>))
          .toList();
      emit(OrderState(orders: orders, status: nextStatus));
    } catch (error) {
      emit(OrderState(orders: state.orders, error: error.toString(), status: nextStatus));
    }
  }

  Future<void> placeOrder(List<CartItem> items, String address, String note) async {
    await api.post('/orders', {
      'shippingAddress': address,
      'note': note,
      'items': items.map((item) => {
            'productId': item.product.id,
            'quantity': item.quantity,
          }).toList(),
    });
    await load(mine: true);
  }

  Future<void> updateStatus(Order order, String status) async {
    await api.patch('/orders/${order.id}/status', {'status': status});
    await load(mine: false);
  }
}
