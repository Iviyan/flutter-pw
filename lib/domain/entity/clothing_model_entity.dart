class ClothingModelEntity {
  late final int id;
  final int clothingManufacturerId;
  final String name;
  final int price;

  ClothingModelEntity({
    required this.clothingManufacturerId,
    required this.name,
    required this.price
  });
}
