part of product_management_app;

class CategoryState {
  const CategoryState({this.categories = const [], this.isLoading = false, this.error});
  final List<Category> categories;
  final bool isLoading;
  final String? error;
}

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this.api) : super(const CategoryState());
  final ApiClient api;

  Future<void> load() async {
    emit(CategoryState(categories: state.categories, isLoading: true));
    try {
      final response = await api.get('/categories');
      final categories = ((response['data'] ?? []) as List<dynamic>)
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList();
      emit(CategoryState(categories: categories));
    } catch (error) {
      emit(CategoryState(categories: state.categories, error: error.toString()));
    }
  }
}
