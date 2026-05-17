part of product_management_app;

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      context.read<ProductCubit>().load();
      context.read<CategoryCubit>().load();
      context.read<OrderCubit>().load(mine: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveShell(
      title: index == 0 ? 'Product Management' : 'Order Management',
      subtitle: index == 0 ? 'Create, edit and publish store products.' : 'Track orders and move them through fulfillment.',
      selectedIndex: index,
      onDestinationSelected: (value) => setState(() => index = value),
      actions: const [LogoutButton()],
      destinations: const [
        ShellDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Products'),
        ShellDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Orders'),
      ],
      children: const [AdminProductPage(), AdminOrderPage()],
      floatingActionButton: index == 0
          ? FloatingActionButton.extended(
              onPressed: () => showProductForm(context),
              icon: const Icon(Icons.add),
              label: const Text('Product'),
            )
          : null,
    );
  }
}
