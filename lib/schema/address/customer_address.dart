import 'package:forwa_app/schema/custom_attribute_data.dart';
import 'package:forwa_app/schema/product/custom_attribute.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_address.g.dart';

@JsonSerializable()
class CustomerAddress extends CustomAttributeData {

  @JsonKey(name: 'customer_id')
  int customerId;

  @JsonKey(name: 'region')
  String region;

  @JsonKey(name: 'region_id')
  int regionId;

  @JsonKey(name: 'country_id')
  String countryId;

  @JsonKey(name: 'street')
  List<String> street;

  @JsonKey(name: 'postcode')
  String postCode;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'firstname')
  String firstName;

  @JsonKey(name: 'lastname')
  String lastName;

  @JsonKey(name: 'telephone')
  String telephone;

  @JsonKey(name: 'default_billing')
  bool defaultBilling;

  @JsonKey(name: 'default_shipping')
  bool defaultShipping;

  CustomerAddress({
    required this.customerId,
    required this.region,
    required this.regionId,
    required this.countryId,
    required this.street,
    required this.postCode,
    required this.city,
    required this.firstName,
    required this.lastName,
    required this.telephone,
    required this.defaultBilling,
    required this.defaultShipping,
    List<CustomAttribute>? customAttributes,
  }) : super(customAttributes: customAttributes);

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      _$CustomerAddressFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerAddressToJson(this);

}