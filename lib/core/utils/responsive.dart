part of product_management_app;

class Responsive {
  static const tabletMin = 600.0;
  static const desktopMin = 1024.0;
  static const wideMin = 1280.0;

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static bool isCompact(BuildContext context) => width(context) < tabletMin;

  static bool isMedium(BuildContext context) {
    final value = width(context);
    return value >= tabletMin && value < desktopMin;
  }

  static bool isExpanded(BuildContext context) => width(context) >= desktopMin;

  static EdgeInsets pagePadding(BuildContext context) {
    if (width(context) >= wideMin) return const EdgeInsets.all(28);
    if (isExpanded(context)) return const EdgeInsets.all(24);
    if (isMedium(context)) return const EdgeInsets.all(20);
    return const EdgeInsets.all(16);
  }

  static double maxContentWidth(BuildContext context) {
    if (width(context) >= wideMin) return 1180;
    if (isExpanded(context)) return 1040;
    return double.infinity;
  }

  static int productGridColumns(double availableWidth) {
    if (availableWidth >= 1320) return 5;
    if (availableWidth >= 1040) return 4;
    if (availableWidth >= 720) return 3;
    return 2;
  }

  static double productCardAspectRatio(double availableWidth) {
    if (availableWidth >= 1040) return 0.78;
    if (availableWidth >= 720) return 0.74;
    if (availableWidth < 390) return 0.60;
    return 0.66;
  }

  static int orderColumns(double availableWidth) => availableWidth >= 980 ? 2 : 1;
}

class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
        child: Padding(
          padding: padding ?? Responsive.pagePadding(context),
          child: child,
        ),
      ),
    );
  }
}

class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.04),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + delay.inMilliseconds),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(offset.dx * (1 - value) * 80, offset.dy * (1 - value) * 80),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
