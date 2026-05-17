part of product_management_app;

class OrderList extends StatelessWidget {
  const OrderList({super.key, required this.mine});
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      padding: EdgeInsets.fromLTRB(
        Responsive.pagePadding(context).left,
        0,
        Responsive.pagePadding(context).right,
        Responsive.pagePadding(context).bottom,
      ),
      child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state.isLoading && state.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.orders.isEmpty) {
            return const EmptyState(icon: Icons.receipt_long_outlined, title: 'No orders yet');
          }
          return RefreshIndicator(
            onRefresh: () => context.read<OrderCubit>().load(mine: mine),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = Responsive.orderColumns(constraints.maxWidth);
                if (columns == 1) {
                  return ListView.separated(
                    itemCount: state.orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => FadeSlideIn(
                      delay: Duration(milliseconds: index.clamp(0, 8).toInt() * 22),
                      child: OrderCard(order: state.orders[index], mine: mine),
                    ),
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) => FadeSlideIn(
                    delay: Duration(milliseconds: index.clamp(0, 8).toInt() * 22),
                    child: OrderCard(order: state.orders[index], mine: mine),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.mine});
  final Order order;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showOrderDetail(context, order, mine: mine),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.orderNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  StatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                mine ? '${order.items.length} items' : '${order.customerName} | ${order.customerEmail}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    money(order.totalAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const Spacer(),
                  Text(shortDate(order.createdAt), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
