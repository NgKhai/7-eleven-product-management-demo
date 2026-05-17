part of product_management_app;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return const EmptyState(icon: Icons.shopping_cart_outlined, title: 'Your cart is empty');
        }

        final list = ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: state.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => FadeSlideIn(
            delay: Duration(milliseconds: index.clamp(0, 8).toInt() * 20),
            child: CartItemTile(item: state.items[index]),
          ),
        );

        final summary = CartSummaryCard(state: state);

        return ResponsiveCenter(
          child: Responsive.isExpanded(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: list),
                    const SizedBox(width: 18),
                    SizedBox(width: 330, child: summary),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: list),
                    const SizedBox(height: 12),
                    summary,
                  ],
                ),
        );
      },
    );
  }
}

class CartSummaryCard extends StatelessWidget {
  const CartSummaryCard({super.key, required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Order summary', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Items'),
                  const Spacer(),
                  Text('${state.count}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Total', style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  Text(money(state.total), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => showCheckout(context),
                icon: const Icon(Icons.payment),
                label: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final compact = Responsive.isCompact(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ProductImage(url: item.product.primaryImage, size: compact ? 54 : 64),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('${money(item.product.price)} x ${item.quantity} = ${money(item.subtotal)}'),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Decrease',
              onPressed: () => context.read<CartCubit>().decrement(item.product),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            IconButton(
              tooltip: 'Increase',
              onPressed: () => context.read<CartCubit>().add(item.product),
              icon: const Icon(Icons.add_circle_outline),
            ),
            IconButton(
              tooltip: 'Remove',
              onPressed: () => context.read<CartCubit>().remove(item.product),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
