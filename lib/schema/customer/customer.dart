import 'package:forwa_app/schema/address/customer_address_response.dart';
import 'package:forwa_app/schema/custom_attribute.dart';
import 'package:forwa_app/schema/custom_extensible_data.dart';
import 'package:forwa_app/schema/extension_attributes.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer extends CustomExtensibleData {

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'firstname')
  String firstName;

  @JsonKey(name: 'lastname')
  String lastName;

  @JsonKey(name: 'store_id')
  int? storeId;

  @JsonKey(name: 'website_id')
  int? websiteId;

  @JsonKey(name: 'addresses')
  List<CustomerAddressResponse>? addresses;

  Customer({
    this.id,
    this.email,
    required this.firstName,
    required this.lastName,
    this.storeId,
    this.websiteId,
    this.addresses,
    List<CustomAttribute>? customAttributes,
    ExtensionAttributes? extensionAttributes,
  }) : super(
    customAttributes: customAttributes,
    extensionAttributes: extensionAttributes,
  );

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  List<Review>? get reviews {
    if(extensionAttributes == null) return null;
    return extensionAttributes!.reviews;
  }

  double? get rating {
    if(extensionAttributes == null) return null;
    return extensionAttributes!.rating;
  }

}