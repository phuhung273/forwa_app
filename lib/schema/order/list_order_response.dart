import 'package:forwa_app/schema/order/order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_order_response.g.dart';

@JsonSerializable()
class ListOrderResponse {

  @JsonKey(name: 'items')
  List<Order>? items;

  ListOrderResponse({
    this.items,
  });

  factory ListOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$ListOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListOrderResponseToJson(this);

}