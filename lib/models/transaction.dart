class FinanceTransaction {
  final String id;
  final String title;
  final double amount;
  final String category;
  final bool isIncome;
  final DateTime? date;

  FinanceTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    this.date,
  });
  factory FinanceTransaction.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return FinanceTransaction(
      id: id,
      title: data['title'] ?? '',
      amount: data['amount'] ?? 0.0,
      category: data['category'] ?? '',
      isIncome: data['isIncome'] ?? false,
      date: data['date']?.toDate(),
    );
  }
}
