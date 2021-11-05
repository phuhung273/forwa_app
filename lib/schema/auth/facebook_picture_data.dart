import 'package:json_annotation/json_annotation.dart';

part 'facebook_picture_data.g.dart';

@JsonSerializable()
class FacebookPictureData {

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'width')
  int width;

  @JsonKey(name: 'height')
  int height;

  FacebookPictureData({
    required this.url,
    required this.width,
    required this.height,
  });

  factory FacebookPictureData.fromJson(Map<String, dynamic> json) =>
      _$FacebookPictureDataFromJson(json);

  Map<String, dynamic> toJson() => _$FacebookPictureDataToJson(this);

}