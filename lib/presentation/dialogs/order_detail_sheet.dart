part of product_management_app;

void showOrderDetail(BuildContext context, Order order, {required bool mine}) {
  final statuses = ['pending', 'processing', 'shipping', 'delivered', 'cancelled'];
  showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => BlocProvider.value(
      value: context.read<OrderCubit>(),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(child: Text(order.orderNumber, style: Theme.of(context).textTheme.headlineSmall)),
                StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            if (!mine) Text('${order.customerName} | ${order.customerEmail}'),
            Text(order.shippingAddress),
            if (order.note.isNotEmpty) Text(order.note),
            const Divider(height: 28),
            ...order.items.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ProductImage(url: item.imageUrl, size: 48),
                  title: Text(item.productName),
                  subtitle: Text('${item.quantity} x ${money(item.unitPrice)}'),
                  trailing: Text(money(item.subtotal)),
                )),
            const Divider(height: 28),
            Text('Total: ${money(order.totalAmount)}', style: Theme.of(context).textTheme.titleLarge),
            if (!mine && !['delivered', 'cancelled'].contains(order.status)) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: order.status,
                decoration: const InputDecoration(labelText: 'Update status'),
                items: statuses.map((status) => DropdownMenuItem(value: status, child: Text(formatStatus(status)))).toList(),
                onChanged: (status) async {
                  if (status == null || status == order.status) return;
                  try {
                    await context.read<OrderCubit>().updateStatus(order, status);
                    if (context.mounted) {
                      Navigator.pop(context);
                      showSnack(context, 'Order status updated');
                    }
                  } catch (error) {
                    if (context.mounted) showSnack(context, error.toString());
                  }
                },
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
