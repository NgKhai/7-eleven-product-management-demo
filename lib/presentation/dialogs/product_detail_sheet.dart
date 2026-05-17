part of product_management_app;

void showProductDetail(BuildContext context, Product product, {required bool admin}) {
  showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    constraints: BoxConstraints(maxWidth: Responsive.isExpanded(context) ? 680 : double.infinity),
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.primaryImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(aspectRatio: 16 / 9, child: ProductImage(url: product.primaryImage, size: double.infinity)),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text(product.name, style: Theme.of(context).textTheme.headlineSmall)),
              StatusChip(status: product.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(product.description),
          const SizedBox(height: 12),
          Text('${money(product.price)} | Stock ${product.stockQuantity} | ${product.categoryName}'),
          const SizedBox(height: 16),
          if (admin)
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showProductForm(context, product: product);
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      confirmDeleteProduct(context, product);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            )
          else
            FilledButton.icon(
              onPressed: product.inStock
                  ? () {
                      context.read<CartCubit>().add(product);
                      Navigator.pop(context);
                      showSnack(context, 'Added to cart');
                    }
                  : null,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to cart'),
            ),
        ],
      ),
    ),
  );
}
