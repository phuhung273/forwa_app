import 'package:json_annotation/json_annotation.dart';

part 'phone_register_request.g.dart';

@JsonSerializable()
class PhoneRegisterRequest {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'password_confirmation')
  String passwordConfirmation;

  PhoneRegisterRequest({
    required this.name,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });

  factory PhoneRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$PhoneRegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneRegisterRequestToJson(this);

}