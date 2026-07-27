class ExpenseFormData {
  final String amount;
  final String title;
  final String category;
  final String? categoryId;
  final String date;
  final DateTime? selectedDate;
  final String paymentMethod;
  final String note;

  const ExpenseFormData({
    this.amount = '0.00',
    this.title = '',
    this.category = 'Select Category',
    this.categoryId,
    this.date = 'Today',
    this.selectedDate,
    this.paymentMethod = 'Card',
    this.note = '',
  });

  ExpenseFormData copyWith({
    String? amount,
    String? title,
    String? category,
    String? categoryId,
    String? date,
    DateTime? selectedDate,
    String? paymentMethod,
    String? note,
  }) {
    return ExpenseFormData(
      amount: amount ?? this.amount,
      title: title ?? this.title,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      selectedDate: selectedDate ?? this.selectedDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
    );
  }
}