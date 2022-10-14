import '../../domain/entity/receipt_entity.dart';

class Receipt extends ReceiptEntity{
  Receipt({
    required super.roleId,
    required super.datetime,
    required super.amount,
  });

  Map<String, dynamic> toMap() => {
    "role_id": roleId,
    "datetime": datetime,
    "amount": amount,
  };

  factory Receipt.fromMap(Map<String, dynamic> json)
   => Receipt(
    roleId: json["role_id"],
    datetime: json["datetime"],
    amount: json["amount"],
  );
}
