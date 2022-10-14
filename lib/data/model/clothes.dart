import '../../domain/entity/clothes_entity.dart';

class Clothes extends ClothesEntity {
  Clothes({
    required super.clothingModelId,
    required super.size,
    required super.sold
  });

  Map<String, dynamic> toMap() => {
    "clothing_model_id": clothingModelId,
    "size": size,
    "sold": sold,
  };

  factory Clothes.fromMap(Map<String, dynamic> json) 
    => Clothes(
      clothingModelId: json["clothing_model_id"],
      size: json["size"],
      sold: json["price"] > 0,
    );
}

