import 'package:forwa_app/schema/user/user.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

enum OrderStatus{
  PROCESSING,
  SELECTED,
  FINISH,
  CANCEL,
}

@JsonSerializable()
class Order {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'product_id')
  int productId;

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'user')
  User? user;

  @JsonKey(name: 'product')
  Product? product;

  Order({
    required this.id,
    required this.status,
    required this.message,
    required this.productId,
    required this.userId,
    this.user,
    this.product,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  String? get sellerName => product?.user?.name;

  String? get firstImageUrl => product?.images.first.url;

  OrderStatus? get statusType{
    return EnumToString.fromString(OrderStatus.values, status.toUpperCase());
  }
}