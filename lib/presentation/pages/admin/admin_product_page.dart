part of product_management_app;

class AdminProductPage extends StatelessWidget {
  const AdminProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      child: Column(
        children: [
          const ProductFilters(admin: true),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state.isLoading && state.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error != null && state.products.isEmpty) {
                  return EmptyState(icon: Icons.error_outline, title: state.error!);
                }
                if (state.products.isEmpty) {
                  return const EmptyState(icon: Icons.inventory_2_outlined, title: 'No products found');
                }
                return RefreshIndicator(
                  onRefresh: () => context.read<ProductCubit>().load(),
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: Responsive.isExpanded(context) ? 24 : 90),
                    itemCount: state.products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return FadeSlideIn(
                        delay: Duration(milliseconds: index.clamp(0, 8).toInt() * 24),
                        child: ProductListTile(product: state.products[index]),
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

class ProductFilters extends StatefulWidget {
  const ProductFilters({super.key, required this.admin});
  final bool admin;

  @override
  State<ProductFilters> createState() => _ProductFiltersState();
}

class _ProductFiltersState extends State<ProductFilters> {
  final controller = TextEditingController();
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  void search(String value) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 450), () {
      context.read<ProductCubit>().load(search: value, status: widget.admin ? null : 'active');
    });
  }

  @override
  Widget build(BuildContext context) {
    final statuses = widget.admin ? [null, 'active', 'out_of_stock', 'inactive'] : [null, 'active'];
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final chips = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: statuses.map((status) {
              final selected = state.status == status || (!widget.admin && status == 'active' && state.status == null);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: selected,
                  label: Text(status == null ? 'All' : formatStatus(status)),
                  avatar: selected ? const Icon(Icons.check, size: 16) : null,
                  onSelected: (_) => context.read<ProductCubit>().load(
                        search: state.search,
                        status: widget.admin ? status : 'active',
                      ),
                ),
              );
            }).toList(),
          ),
        );

        final searchField = TextField(
          controller: controller,
          onChanged: search,
          decoration: InputDecoration(
            hintText: 'Search products',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.clear();
                      context.read<ProductCubit>().load(search: '', status: widget.admin ? state.status : 'active');
                      setState(() {});
                    },
                  ),
          ),
        );

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE1E8E4)),
          ),
          child: Responsive.isExpanded(context)
              ? Row(
                  children: [
                    Expanded(child: searchField),
                    const SizedBox(width: 14),
                    Flexible(child: chips),
                  ],
                )
              : Column(
                  children: [
                    searchField,
                    const SizedBox(height: 10),
                    Align(alignment: Alignment.centerLeft, child: chips),
                  ],
                ),
        );
      },
    );
  }
}

class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final compact = Responsive.isCompact(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showProductDetail(context, product, admin: true),
        child: Padding(
          padding: EdgeInsets.all(compact ? 10 : 14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ProductImage(url: product.primaryImage, size: compact ? 58 : 72),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      children: [
                        Text(money(product.price), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w800)),
                        Text('Stock ${product.stockQuantity}'),
                        if (product.categoryName.isNotEmpty) Text(product.categoryName),
                      ],
                    ),
                  ],
                ),
              ),
              if (!compact) StatusChip(status: product.status),
              if (!compact) const SizedBox(width: 8),
              IconButton(
                tooltip: 'Edit',
                onPressed: () => showProductForm(context, product: product),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: () => confirmDeleteProduct(context, product),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
