class Category {
  final String id;
  final String name;
  final String icon;
  final String color;
  final bool isDefault;
  final String type;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isDefault,
    this.type = 'EXPENSE',
  });
}
