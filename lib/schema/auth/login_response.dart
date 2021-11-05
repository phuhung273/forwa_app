import 'package:forwa_app/schema/customer/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {

  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'store_code')
  String storeCode;

  @JsonKey(name: 'store_website_id')
  int storeWebsiteId;

  @JsonKey(name: 'customer')
  Customer customer;

  LoginResponse({
    required this.accessToken,
    required this.customer,
    required this.storeCode,
    required this.storeWebsiteId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

}