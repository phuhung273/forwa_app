import 'package:json_annotation/json_annotation.dart';

part 'email_register_request.g.dart';

@JsonSerializable()
class EmailRegisterRequest {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'password_confirmation')
  String passwordConfirmation;

  EmailRegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory EmailRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$EmailRegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmailRegisterRequestToJson(this);

}