part of product_management_app;

class AdminOrderPage extends StatefulWidget {
  const AdminOrderPage({super.key});

  @override
  State<AdminOrderPage> createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  final statuses = [null, 'pending', 'processing', 'shipping', 'delivered', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatusFilterBar(
          statuses: statuses,
          onSelected: (status) => context.read<OrderCubit>().load(mine: false, status: status),
        ),
        Expanded(child: OrderList(mine: false)),
      ],
    );
  }
}
