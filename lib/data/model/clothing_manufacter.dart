import '../../domain/entity/clothing_manufacter_entity.dart';

class ClothingManufacter extends ClothingManufacterEntity{
  ClothingManufacter({required super.name});

  Map<String, dynamic> toMap() => {
    "name": name
  };

  factory ClothingManufacter.fromMap(Map<String, dynamic> json) 
    => ClothingManufacter(name: json["name"]);
}
