import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/schema/product/extension_attributes.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

enum OrderStatus{
  PENDING,
  PROCESSING,
  SUCCESS,
  CANCELED,
}

@JsonSerializable()
class Order {

  @JsonKey(name: 'entity_id')
  int id;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'items')
  List<Product> items;

  @JsonKey(name: 'extension_attributes')
  ExtensionAttributes? extensionAttributes;

  Order({
    required this.id,
    required this.status,
    required this.items,
    this.extensionAttributes,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  String? get firstImageUrl {
    if(extensionAttributes == null || extensionAttributes!.imageUrls == null || extensionAttributes!.imageUrls!.isEmpty) return null;
    return extensionAttributes!.imageUrls!.first;
  }

  String? get sellerName {
    if(extensionAttributes == null) return null;
    return extensionAttributes!.sellerName;
  }

  OrderStatus? get statusType{
    return EnumToString.fromString(OrderStatus.values, status.toUpperCase());
  }
}