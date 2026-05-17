part of product_management_app;

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, required this.size});
  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      color: const Color(0xFFEAF1ED),
      child: const Icon(Icons.image_outlined),
    );
    if (url.isEmpty) return placeholder;
    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: child,
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return placeholder;
      },
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
