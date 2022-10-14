import '../../domain/entity/cart_entity.dart';

class Cart extends CartEntity{
  Cart({
    required super.roleId,
    required super.clothesId,
  });

  Map<String, dynamic> toMap() => {
    "role_id": roleId,
    "clothes_id": clothesId,
  };

  factory Cart.fromMap(Map<String, dynamic> json)
   => Cart(roleId: json["role_id"], clothesId: json["clothes_id"]);
}
