part of product_management_app;

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(icon, size: 34),
                  ),
                  const SizedBox(height: 16),
                  Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
