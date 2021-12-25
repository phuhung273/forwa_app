import 'package:json_annotation/json_annotation.dart';

part 'product_list_request.g.dart';

@JsonSerializable()
class ProductListRequest {

  @JsonKey(name: 'hidden_user_ids')
  List<int> hiddenUserIds;

  @JsonKey(name: 'latitude')
  double latitude;

  @JsonKey(name: 'longitude')
  double longitude;

  ProductListRequest({
    required this.hiddenUserIds,
    required this.latitude,
    required this.longitude,
  });

  factory ProductListRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListRequestToJson(this);

}