class ExpenseFormData {
  final String amount;
  final String category;
  final String date;
  final String paymentMethod;
  final String note;

  const ExpenseFormData({
    this.amount = '0.00',
    this.category = 'Select Category',
    this.date = 'Today',
    this.paymentMethod = 'Card',
    this.note = '',
  });

  ExpenseFormData copyWith({
    String? amount,
    String? category,
    String? date,
    String? paymentMethod,
    String? note,
  }) {
    return ExpenseFormData(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
    );
  }
}