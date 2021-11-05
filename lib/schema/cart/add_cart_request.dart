import 'package:forwa_app/schema/cart/cart_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_cart_request.g.dart';

@JsonSerializable()
class AddCartRequest {

  @JsonKey(name: 'cartItem')
  CartItem cartItem;

  @JsonKey(name: 'message')
  String message;

  AddCartRequest({
    required this.cartItem,
    required this.message,
  });

  factory AddCartRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCartRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddCartRequestToJson(this);

}