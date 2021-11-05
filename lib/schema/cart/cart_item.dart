import 'package:json_annotation/json_annotation.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {

  @JsonKey(name: 'sku')
  String sku;

  @JsonKey(name: 'qty')
  int quantity;

  CartItem({
    required this.sku,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

}