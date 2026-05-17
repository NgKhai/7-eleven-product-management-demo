part of product_management_app;

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final statuses = [null, 'pending', 'processing', 'shipping', 'delivered', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatusFilterBar(
          statuses: statuses,
          onSelected: (status) => context.read<OrderCubit>().load(mine: true, status: status),
        ),
        const Expanded(child: OrderList(mine: true)),
      ],
    );
  }
}
