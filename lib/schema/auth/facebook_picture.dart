import 'package:forwa_app/schema/auth/facebook_picture_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'facebook_picture.g.dart';

@JsonSerializable()
class FacebookPicture {

  @JsonKey(name: 'data')
  FacebookPictureData data;

  FacebookPicture({
    required this.data,
  });

  factory FacebookPicture.fromJson(Map<String, dynamic> json) =>
      _$FacebookPictureFromJson(json);

  Map<String, dynamic> toJson() => _$FacebookPictureToJson(this);

}