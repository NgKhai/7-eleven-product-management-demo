part of product_management_app;

String money(double value) => '\$${value.toStringAsFixed(2)}';

String shortDate(DateTime value) => '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

String formatStatus(String value) {
  return value
      .split('_')
      .map((part) => part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
