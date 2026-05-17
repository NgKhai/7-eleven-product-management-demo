part of product_management_app;

Future<void> showCheckout(BuildContext context) async {
  final addressController = TextEditingController();
  final noteController = TextEditingController();
  final cart = context.read<CartCubit>();
  final orders = context.read<OrderCubit>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(maxWidth: Responsive.isExpanded(context) ? 560 : double.infinity),
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (sheetContext) {
      var isSaving = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return FadeSlideIn(
            child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Checkout', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Shipping address'),
                  minLines: 2,
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Note'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                BlocBuilder<CartCubit, CartState>(
                  bloc: cart,
                  builder: (context, state) => Text('Total: ${money(state.total)}', style: Theme.of(context).textTheme.titleLarge),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (addressController.text.trim().isEmpty) {
                            showSnack(sheetContext, 'Shipping address is required');
                            return;
                          }
                          setState(() => isSaving = true);
                          try {
                            await orders.placeOrder(cart.state.items, addressController.text.trim(), noteController.text.trim());
                            cart.clear();
                            if (sheetContext.mounted) {
                              Navigator.pop(sheetContext);
                              showSnack(sheetContext, 'Order placed');
                            }
                          } catch (error) {
                            if (sheetContext.mounted) showSnack(sheetContext, error.toString());
                          } finally {
                            if (context.mounted) setState(() => isSaving = false);
                          }
                        },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Place order'),
                ),
              ],
            ),
          ));
        },
      );
    },
  );
}
