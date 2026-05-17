part of product_management_app;

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      context.read<ProductCubit>().load(status: 'active');
      context.read<CategoryCubit>().load();
      context.read<OrderCubit>().load(mine: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Products', 'Cart', 'My Orders'];
    return AdaptiveShell(
      title: titles[index],
      subtitle: index == 0 ? 'Browse products and build your basket.' : index == 1 ? 'Review quantities before checkout.' : 'Follow your recent order history.',
      selectedIndex: index,
      onDestinationSelected: (value) => setState(() => index = value),
      actions: [
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) => Badge(
            isLabelVisible: state.count > 0,
            label: Text('${state.count}'),
            child: IconButton(
              tooltip: 'Cart',
              onPressed: () => setState(() => index = 1),
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ),
        const LogoutButton(),
      ],
      destinations: const [
        ShellDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Products'),
        ShellDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Cart'),
        ShellDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: 'Orders'),
      ],
      children: const [ProductCatalogPage(), CartPage(), MyOrdersPage()],
    );
  }
}
