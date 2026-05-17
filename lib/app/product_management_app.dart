part of product_management_app;

class ProductManagementApp extends StatelessWidget {
  const ProductManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiClient(apiBaseUrl);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(api)..checkAuth()),
        BlocProvider(create: (_) => CategoryCubit(api)..load()),
        BlocProvider(create: (_) => ProductCubit(api)..load()),
        BlocProvider(create: (_) => OrderCubit(api)),
        BlocProvider(create: (_) => CartCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '7-Eleven Product Management',
        theme: AppTheme.light(),
        home: const RootView(),
      ),
    );
  }
}

