import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'sku')
  String sku;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'product_id')
  int productId;

  OrderItem({
    required this.name,
    required this.sku,
    required this.createdAt,
    required this.productId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

}