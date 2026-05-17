part of product_management_app;

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'active' || 'delivered' => const Color(0xFF008060),
      'pending' => const Color(0xFFF9A825),
      'processing' => const Color(0xFF1976D2),
      'shipping' => const Color(0xFF6A1B9A),
      'cancelled' || 'inactive' => const Color(0xFFE53935),
      'out_of_stock' => const Color(0xFF757575),
      _ => const Color(0xFF607D8B),
    };
    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text(formatStatus(status), style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
      side: BorderSide.none,
    );
  }
}
