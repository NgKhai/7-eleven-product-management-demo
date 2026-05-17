part of product_management_app;

String? requiredField(String? value) {
  return value == null || value.trim().isEmpty ? 'Required' : null;
}

String? numberField(String? value) {
  final number = double.tryParse(value ?? '');
  return number == null || number < 0 ? 'Enter a valid number' : null;
}

String? intField(String? value) {
  final number = int.tryParse(value ?? '');
  return number == null || number < 0 ? 'Enter a valid whole number' : null;
}
