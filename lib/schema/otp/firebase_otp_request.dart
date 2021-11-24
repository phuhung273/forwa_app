import 'package:json_annotation/json_annotation.dart';

part 'firebase_otp_request.g.dart';

@JsonSerializable()
class FirebaseOtpRequest {

  @JsonKey(name: 'phoneNumber')
  String phone;

  FirebaseOtpRequest({
    required this.phone,
  });

  factory FirebaseOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$FirebaseOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseOtpRequestToJson(this);

}