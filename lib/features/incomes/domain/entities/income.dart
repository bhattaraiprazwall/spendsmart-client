class Income {
  final String id;
  final String type;
  final double amount;
  final String title;
  final String? note;
  final String paymentMethod;
  final DateTime date;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Income({
    required this.id,
    required this.type,
    required this.amount,
    required this.title,
    this.note,
    required this.paymentMethod,
    required this.date,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.createdAt,
    required this.updatedAt,
  });
}
