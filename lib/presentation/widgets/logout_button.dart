part of product_management_app;

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Logout',
      onPressed: () => context.read<AuthCubit>().logout(),
      icon: const Icon(Icons.logout),
    );
  }
}
