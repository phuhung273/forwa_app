import 'package:json_annotation/json_annotation.dart';

part 'lazy_product_request.g.dart';

@JsonSerializable()
class LazyProductRequest {

  @JsonKey(name: 'hidden_user_ids')
  List<int> hiddenUserIds;

  @JsonKey(name: 'latitude')
  double latitude;

  @JsonKey(name: 'longitude')
  double longitude;

  @JsonKey(name: 'take')
  int take;

  @JsonKey(name: 'low_id')
  int lowId;

  @JsonKey(name: 'high_id')
  int highId;

  LazyProductRequest({
    required this.hiddenUserIds,
    required this.latitude,
    required this.longitude,
    this.take = 10,
    required this.lowId,
    required this.highId,
  });

  factory LazyProductRequest.fromJson(Map<String, dynamic> json) =>
      _$LazyProductRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LazyProductRequestToJson(this);

}