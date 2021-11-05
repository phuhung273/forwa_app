import 'package:forwa_app/schema/address/customer_address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_address_request.g.dart';

@JsonSerializable()
class CreateAddressRequest {

  @JsonKey(name: 'address')
  CustomerAddress address;

  CreateAddressRequest({
    required this.address,
  });

  factory CreateAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAddressRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAddressRequestToJson(this);

}