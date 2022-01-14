import 'package:json_annotation/json_annotation.dart';

part 'product_list_request.g.dart';

@JsonSerializable()
class ProductListRequest {

  @JsonKey(name: 'hidden_user_ids')
  List<int> hiddenUserIds;

  @JsonKey(name: 'latitude')
  double? latitude;

  @JsonKey(name: 'longitude')
  double? longitude;

  @JsonKey(name: 'unique_device_id')
  String? uniqueDeviceId;

  @JsonKey(name: 'device_name')
  String? deviceName;

  ProductListRequest({
    required this.hiddenUserIds,
    this.latitude,
    this.longitude,
    this.uniqueDeviceId,
    this.deviceName,
  });

  factory ProductListRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListRequestToJson(this);

}