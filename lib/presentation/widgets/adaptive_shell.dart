part of product_management_app;

class ShellDestination {
  const ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selectedIndex,
    required this.destinations,
    required this.children,
    required this.onDestinationSelected,
    this.actions = const [],
    this.floatingActionButton,
  });

  final String title;
  final String subtitle;
  final int selectedIndex;
  final List<ShellDestination> destinations;
  final List<Widget> children;
  final ValueChanged<int> onDestinationSelected;
  final List<Widget> actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final expanded = Responsive.isExpanded(context);
    final activeBody = AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final offset = Tween<Offset>(
          begin: const Offset(0.02, 0),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offset, child: child),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(selectedIndex),
        child: children[selectedIndex],
      ),
    );

    if (!expanded) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: actions,
        ),
        body: activeBody,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations
              .map(
                (item) => NavigationDestination(
                  icon: item.icon,
                  selectedIcon: item.selectedIcon,
                  label: item.label,
                ),
              )
              .toList(),
        ),
        floatingActionButton: floatingActionButton,
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.sizeOf(context).width >= Responsive.wideMin,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: MediaQuery.sizeOf(context).width >= Responsive.wideMin
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.local_convenience_store),
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            destinations: destinations
                .map(
                  (item) => NavigationRailDestination(
                    icon: item.icon,
                    selectedIcon: item.selectedIcon,
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 22, 28, 18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: const Border(bottom: BorderSide(color: Color(0xFFE1E8E4))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      if (floatingActionButton != null) floatingActionButton!,
                    ],
                  ),
                ),
                Expanded(child: activeBody),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
