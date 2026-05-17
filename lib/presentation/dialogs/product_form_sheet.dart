part of product_management_app;

Future<void> showProductForm(BuildContext context, {Product? product}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(maxWidth: Responsive.isExpanded(context) ? 720 : double.infinity),
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) => BlocProvider.value(
      value: context.read<ProductCubit>(),
      child: BlocProvider.value(
        value: context.read<CategoryCubit>(),
        child: ProductFormSheet(product: product),
      ),
    ),
  );
}

class ProductFormSheet extends StatefulWidget {
  const ProductFormSheet({super.key, this.product});
  final Product? product;

  @override
  State<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<ProductFormSheet> {
  final formKey = GlobalKey<FormState>();
  late final nameController = TextEditingController(text: widget.product?.name ?? '');
  late final descriptionController = TextEditingController(text: widget.product?.description ?? '');
  late final priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
  late final stockController = TextEditingController(text: widget.product?.stockQuantity.toString() ?? '');
  String? categoryId;
  String status = 'active';
  final pickedImages = <PickedImage>[];
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    categoryId = widget.product?.categoryId;
    status = widget.product?.status ?? 'active';
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(imageQuality: 84);
    if (files.isEmpty) return;
    final limited = files.take(5 - pickedImages.length);
    final next = <PickedImage>[];
    for (final file in limited) {
      next.add(PickedImage(name: file.name, bytes: await file.readAsBytes()));
    }
    setState(() => pickedImages.addAll(next));
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate() || categoryId == null) {
      showSnack(context, 'Please complete all required fields');
      return;
    }
    setState(() => isSaving = true);
    try {
      await context.read<ProductCubit>().createOrUpdate(
            existing: widget.product,
            images: pickedImages,
            fields: {
              'name': nameController.text.trim(),
              'description': descriptionController.text.trim(),
              'price': priceController.text.trim(),
              'stockQuantity': stockController.text.trim(),
              'categoryId': categoryId!,
              'status': status,
              if (widget.product != null && pickedImages.isNotEmpty) 'replaceImages': 'false',
            },
          );
      if (mounted) {
        Navigator.pop(context);
        showSnack(context, widget.product == null ? 'Product created' : 'Product updated');
      }
    } catch (error) {
      if (mounted) showSnack(context, error.toString());
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            key: formKey,
            child: ListView(
              controller: scrollController,
              children: [
                Text(widget.product == null ? 'Add Product' : 'Edit Product', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: pickedImages.length >= 5 ? null : pickImages,
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: Text(pickedImages.isEmpty ? 'Pick images' : '${pickedImages.length} image selected'),
                ),
                if (widget.product?.images.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text('Existing images remain unless you delete the product.', style: Theme.of(context).textTheme.bodySmall),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: requiredField,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  validator: requiredField,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: numberField,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stock quantity'),
                  keyboardType: TextInputType.number,
                  validator: intField,
                ),
                const SizedBox(height: 12),
                BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    final selectedCategory = state.categories.any((category) => category.id == categoryId) ? categoryId : null;
                    return DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: state.categories
                          .map((category) => DropdownMenuItem(value: category.id, child: Text(category.name)))
                          .toList(),
                      onChanged: (value) => setState(() => categoryId = value),
                      validator: (value) => value == null ? 'Category is required' : null,
                    );
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                    DropdownMenuItem(value: 'out_of_stock', child: Text('Out of stock')),
                  ],
                  onChanged: (value) => setState(() => status = value ?? 'active'),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: isSaving ? null : save,
                  icon: isSaving
                      ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save_outlined),
                  label: const Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
