import 'package:json_annotation/json_annotation.dart';

part 'firebase_token.g.dart';

@JsonSerializable()
class FirebaseToken {

  @JsonKey(name: 'value')
  String value;

  @JsonKey(name: 'device_name')
  String deviceName;

  FirebaseToken({
    required this.value,
    required this.deviceName,
  });

  factory FirebaseToken.fromJson(Map<String, dynamic> json) =>
      _$FirebaseTokenFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseTokenToJson(this);

}