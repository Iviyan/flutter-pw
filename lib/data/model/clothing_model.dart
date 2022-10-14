import '../../domain/entity/clothing_model_entity.dart';

class ClothingModel extends ClothingModelEntity {
  ClothingModel({
    required super.clothingManufacturerId,
    required super.name,
    required super.price
  });

  Map<String, dynamic> toMap() => {
    "name": name,
    "clothing_manufacturer_id": clothingManufacturerId,
    "price": price,
  };

  factory ClothingModel.fromMap(Map<String, dynamic> json) 
    => ClothingModel(
      name: json["name"],
      clothingManufacturerId: json["clothing_manufacturer_id"],
      price: json["price"],
    );
}
