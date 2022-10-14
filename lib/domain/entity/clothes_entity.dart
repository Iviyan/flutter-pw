class ClothesEntity {
  late final int id;
  final int clothingModelId;
  final int size;
  final bool sold;

  ClothesEntity({
    required this.clothingModelId,
    required this.size,
    required this.sold
  });
}
