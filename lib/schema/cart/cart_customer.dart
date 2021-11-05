import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_customer.g.dart';

@JsonSerializable()
class CartCustomer {

  @JsonKey(name: 'item_id')
  int cartItemId;

  @JsonKey(name: 'sku')
  String sku;

  @JsonKey(name: 'name')
  String productName;

  @JsonKey(name: 'quote_id')
  int cartId;

  @JsonKey(name: 'customer_id')
  int customerId;

  @JsonKey(name: 'product_id')
  int productId;

  @JsonKey(name: 'customer_first_name')
  String customerFirstName;

  @JsonKey(name: 'customer_last_name')
  String customerLastName;

  @JsonKey(name: 'order_id')
  int orderId;

  @JsonKey(name: 'order_item_id')
  int orderItemId;

  @JsonKey(name: 'customer_note')
  String? customerNote;

  @JsonKey(name: 'order_status')
  String orderStatus;

  CartCustomer({
    required this.cartItemId,
    required this.sku,
    required this.productName,
    required this.cartId,
    required this.customerId,
    required this.productId,
    required this.customerFirstName,
    required this.customerLastName,
    required this.orderId,
    required this.orderItemId,
    this.customerNote,
    required this.orderStatus,
  });

  factory CartCustomer.fromJson(Map<String, dynamic> json) =>
      _$CartCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CartCustomerToJson(this);

  OrderStatus? get status {
    return EnumToString.fromString(OrderStatus.values, orderStatus.toUpperCase());
  }
}