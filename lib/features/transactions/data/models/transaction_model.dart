class TransactionModel {
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

  const TransactionModel({
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

  bool get isIncome => type == 'INCOME';

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final category = json["category"] as Map<String, dynamic>?;
    return TransactionModel(
      id: json["id"] as String,
      type: json["type"] as String,
      amount: double.parse(json["amount"].toString()),
      title: json["title"] as String,
      note: json["note"] as String?,
      paymentMethod: json["paymentMethod"] as String,
      date: DateTime.parse(json["date"] as String),
      categoryId: json["categoryId"] as String,
      categoryName: category?["name"] as String? ?? "",
      categoryIcon: category?["icon"] as String? ?? "category",
      categoryColor: category?["color"] as String? ?? "#3D5CFF",
      createdAt: DateTime.parse(json["createdAt"] as String),
      updatedAt: DateTime.parse(json["updatedAt"] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "amount": amount,
      "title": title,
      "note": note,
      "paymentMethod": paymentMethod,
      "date": date.toIso8601String(),
      "categoryId": categoryId,
    };
  }
}
