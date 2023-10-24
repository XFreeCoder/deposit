enum TransactionType { income, expense }

class Transaction {
  final int id;
  final int depositPlanId;
  final String name;
  final num amount;
  final TransactionType type;
  final String tags;

  const Transaction({
    required this.id,
    required this.depositPlanId,
    required this.name,
    required this.amount,
    required this.type,
    required this.tags,
  });
}
