import 'package:forwa_app/schema/order/order.dart';
import 'package:json_annotation/json_annotation.dart';
import '../product/product.dart';

part 'list_orders_of_product_response.g.dart';

@JsonSerializable()
class ListOrdersOfProductResponse {

  @JsonKey(name: 'product')
  Product product;

  @JsonKey(name: 'orders')
  List<Order> orders;

  ListOrdersOfProductResponse({
    required this.product,
    required this.orders,
  });

  factory ListOrdersOfProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ListOrdersOfProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListOrdersOfProductResponseToJson(this);

}