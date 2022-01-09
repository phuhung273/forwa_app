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

  @JsonKey(name: 'low_product_id')
  int lowProductId;

  @JsonKey(name: 'high_product_id')
  int highProductId;

  LazyProductRequest({
    required this.hiddenUserIds,
    required this.latitude,
    required this.longitude,
    this.take = 10,
    required this.lowProductId,
    required this.highProductId,
  });

  factory LazyProductRequest.fromJson(Map<String, dynamic> json) =>
      _$LazyProductRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LazyProductRequestToJson(this);

}