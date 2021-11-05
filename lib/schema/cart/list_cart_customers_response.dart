import 'package:forwa_app/schema/cart/cart_customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_cart_customers_response.g.dart';

@JsonSerializable()
class ListCartCustomersResponse {

  @JsonKey(name: 'items')
  List<CartCustomer>? customers;

  ListCartCustomersResponse({
    this.customers,
  });

  factory ListCartCustomersResponse.fromJson(Map<String, dynamic> json) =>
      _$ListCartCustomersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListCartCustomersResponseToJson(this);

}