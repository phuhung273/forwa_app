import 'package:json_annotation/json_annotation.dart';

part 'customer_address_response.g.dart';

@JsonSerializable()
class CustomerAddressResponse {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'customer_id')
  int customerId;

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
  bool? defaultBilling;

  @JsonKey(name: 'default_shipping')
  bool? defaultShipping;

  CustomerAddressResponse({
    required this.id,
    required this.customerId,
    required this.countryId,
    required this.street,
    required this.postCode,
    required this.city,
    required this.firstName,
    required this.lastName,
    required this.telephone,
    this.defaultBilling,
    this.defaultShipping,
  });

  factory CustomerAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerAddressResponseToJson(this);

}