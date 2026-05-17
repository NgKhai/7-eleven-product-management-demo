part of product_management_app;

Future<void> confirmDeleteProduct(BuildContext context, Product product) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete product'),
      content: Text('Delete ${product.name}?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  try {
    await context.read<ProductCubit>().deleteProduct(product.id);
    if (context.mounted) showSnack(context, 'Product deleted');
  } catch (error) {
    if (context.mounted) showSnack(context, error.toString());
  }
}
