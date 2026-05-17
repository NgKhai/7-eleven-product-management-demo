part of product_management_app;

class ProductState {
  const ProductState({
    this.products = const [],
    this.page = 1,
    this.hasNextPage = false,
    this.isLoading = false,
    this.error,
    this.search = '',
    this.status,
    this.categoryId,
  });

  final List<Product> products;
  final int page;
  final bool hasNextPage;
  final bool isLoading;
  final String? error;
  final String search;
  final String? status;
  final String? categoryId;
}

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this.api) : super(const ProductState());
  final ApiClient api;

  Future<void> load({String? search, Object? status = _unset, Object? categoryId = _unset, bool append = false}) async {
    if (state.isLoading) return;
    final nextPage = append ? state.page + 1 : 1;
    final nextSearch = search ?? state.search;
    final nextStatus = identical(status, _unset) ? state.status : status as String?;
    final nextCategoryId = identical(categoryId, _unset) ? state.categoryId : categoryId as String?;
    emit(ProductState(
      products: append ? state.products : const [],
      page: state.page,
      hasNextPage: state.hasNextPage,
      isLoading: true,
      search: nextSearch,
      status: nextStatus,
      categoryId: nextCategoryId,
    ));

    try {
      final response = await api.get('/products', {
        'page': nextPage,
        'limit': 20,
        'search': nextSearch,
        'status': nextStatus,
        'categoryId': nextCategoryId,
      });
      final loaded = ((response['data'] ?? []) as List<dynamic>)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
      final meta = (response['meta'] ?? {}) as Map<String, dynamic>;
      emit(ProductState(
        products: append ? [...state.products, ...loaded] : loaded,
        page: nextPage,
        hasNextPage: meta['hasNextPage'] == true,
        search: nextSearch,
        status: nextStatus,
        categoryId: nextCategoryId,
      ));
    } catch (error) {
      emit(ProductState(
        products: state.products,
        page: state.page,
        hasNextPage: state.hasNextPage,
        error: error.toString(),
        search: state.search,
        status: state.status,
        categoryId: state.categoryId,
      ));
    }
  }

  Future<void> createOrUpdate({
    Product? existing,
    required Map<String, String> fields,
    required List<PickedImage> images,
  }) async {
    final method = existing == null ? 'POST' : 'PUT';
    final path = existing == null ? '/products' : '/products/${existing.id}';
    await api.multipart(method, path, fields, images);
    await load();
  }

  Future<void> deleteProduct(String id) async {
    await api.delete('/products/$id');
    await load();
  }
}
