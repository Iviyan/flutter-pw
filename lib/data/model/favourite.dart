import '../../domain/entity/favourite_entity.dart';

class Favourite extends FavouriteEntity{
  Favourite({
    required super.roleId,
    required super.clothesId,
  });

  Map<String, dynamic> toMap() => {
    "role_id": roleId,
    "clothes_id": clothesId,
  };

  factory Favourite.fromMap(Map<String, dynamic> json)
   => Favourite(roleId: json["role_id"], clothesId: json["clothes_id"]);
}
