class DepositPlan {
  final int id;
  final num target;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  const DepositPlan({
    required this.id,
    required this.target,
    required this.name,
    required this.startDate,
    required this.endDate,
  });
}
