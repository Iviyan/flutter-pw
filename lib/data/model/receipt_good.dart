import '../../domain/entity/receipt_good_entity.dart';

class ReceiptGood extends ReceiptGoodEntity{
  ReceiptGood({
    required super.receiptId,
    required super.clothesId,
  });

  Map<String, dynamic> toMap() => {
    "receipt_id": receiptId,
    "clothes_id": clothesId,
  };

  factory ReceiptGood.fromMap(Map<String, dynamic> json)
   => ReceiptGood(receiptId: json["receipt_id"], clothesId: json["clothes_id"]);
}
