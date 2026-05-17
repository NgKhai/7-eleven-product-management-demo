part of product_management_app;

class StatusFilterBar extends StatelessWidget {
  const StatusFilterBar({super.key, required this.statuses, required this.onSelected});
  final List<String?> statuses;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      padding: EdgeInsets.fromLTRB(
        Responsive.pagePadding(context).left,
        Responsive.pagePadding(context).top,
        Responsive.pagePadding(context).right,
        14,
      ),
      child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE1E8E4)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: statuses.map((status) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: state.status == status,
                      avatar: state.status == status ? const Icon(Icons.check, size: 16) : null,
                      label: Text(status == null ? 'All' : formatStatus(status)),
                      onSelected: (_) => onSelected(status),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
