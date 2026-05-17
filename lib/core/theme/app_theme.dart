part of product_management_app;

class AppTheme {
  static ThemeData light() {
    const seed = Color(0xFF008060);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        primary: seed,
        secondary: const Color(0xFFE53935),
        tertiary: const Color(0xFFF9A825),
        surface: const Color(0xFFF8FAF9),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAF9),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFFF8FAF9),
        foregroundColor: Color(0xFF17201B),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE1E8E4)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: Color(0xFFD8E3DD)),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Color(0xFFE0F3EC),
        selectedIconTheme: IconThemeData(color: Color(0xFF008060)),
        selectedLabelTextStyle: TextStyle(color: Color(0xFF008060), fontWeight: FontWeight.w700),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE0F3EC),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

