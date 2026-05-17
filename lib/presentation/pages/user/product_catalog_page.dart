part of product_management_app;

class ProductCatalogPage extends StatelessWidget {
  const ProductCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      child: Column(
        children: [
          const ProductFilters(admin: false),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state.isLoading && state.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.products.isEmpty) {
                  return const EmptyState(icon: Icons.storefront_outlined, title: 'No active products yet');
                }
                return RefreshIndicator(
                  onRefresh: () => context.read<ProductCubit>().load(status: 'active'),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = Responsive.productGridColumns(constraints.maxWidth);
                      return GridView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          childAspectRatio: Responsive.productCardAspectRatio(constraints.maxWidth),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return FadeSlideIn(
                            delay: Duration(milliseconds: index.clamp(0, 10).toInt() * 18),
                            child: ProductCard(product: state.products[index]),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedScale(
        scale: hovering ? 1.015 : 1,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => showProductDetail(context, product, admin: false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ProductImage(url: product.primaryImage, size: double.infinity),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: StatusChip(status: product.inStock ? 'active' : product.status),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        money(product.price),
                        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.stockQuantity > 0 ? '${product.stockQuantity} in stock' : 'Out of stock',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonalIcon(
                          onPressed: product.inStock
                              ? () {
                                  context.read<CartCubit>().add(product);
                                  showSnack(context, 'Added to cart');
                                }
                              : null,
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
