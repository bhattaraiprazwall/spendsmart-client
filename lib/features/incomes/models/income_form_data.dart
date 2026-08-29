class IncomeFormData {
  final String amount;
  final String title;
  final String category;
  final String? categoryId;
  final String date;
  final DateTime? selectedDate;
  final String note;

  const IncomeFormData({
    this.amount = '0.00',
    this.title = '',
    this.category = 'Select Category',
    this.categoryId,
    this.date = 'Today',
    this.selectedDate,
    this.note = '',
  });

  IncomeFormData copyWith({
    String? amount,
    String? title,
    String? category,
    String? categoryId,
    String? date,
    DateTime? selectedDate,
    String? note,
  }) {
    return IncomeFormData(
      amount: amount ?? this.amount,
      title: title ?? this.title,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      selectedDate: selectedDate ?? this.selectedDate,
      note: note ?? this.note,
    );
  }
}
