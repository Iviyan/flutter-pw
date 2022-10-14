class ReceiptEntity {
  late final int id;
  final int roleId;
  final int datetime;
  final double amount;

  ReceiptEntity({
    required this.roleId,
    required this.datetime,
    required this.amount
  });
}
