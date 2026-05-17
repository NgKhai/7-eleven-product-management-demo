part of product_management_app;

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.checking) {
          return const LoadingScaffold(message: 'Checking session');
        }
        if (state.status == AuthStatus.unauthenticated) {
          return const LoginPage();
        }
        final user = state.user!;
        return user.isAdmin ? const AdminDashboardPage() : const UserHomePage();
      },
    );
  }
}
class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}
