import 'package:json_annotation/json_annotation.dart';

part 'create_order_request.g.dart';

@JsonSerializable()
class CreateOrderRequest {

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'product_id')
  int productId;

  CreateOrderRequest({
    required this.message,
    required this.productId,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);

}