import 'package:forwa_app/schema/customer/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {

  @JsonKey(name: 'customer')
  Customer customer;

  @JsonKey(name: 'password')
  String password;

  RegisterRequest({
    required this.customer,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

}