import 'package:json_annotation/json_annotation.dart';

part 'reset_password_phone_request.g.dart';

@JsonSerializable()
class ResetPasswordPhoneRequest {

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'password_confirmation')
  String passwordConfirmation;

  @JsonKey(name: 'token')
  String token;

  ResetPasswordPhoneRequest({
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.token,
  });

  factory ResetPasswordPhoneRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordPhoneRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordPhoneRequestToJson(this);

}