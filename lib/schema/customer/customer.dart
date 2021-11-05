import 'package:forwa_app/schema/address/customer_address_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {

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
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

}