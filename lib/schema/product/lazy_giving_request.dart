import 'package:json_annotation/json_annotation.dart';

part 'lazy_giving_request.g.dart';

@JsonSerializable()
class LazyGivingRequest {

  @JsonKey(name: 'take')
  int take;

  @JsonKey(name: 'low_id')
  int lowId;

  LazyGivingRequest({
    this.take = 10,
    required this.lowId,
  });

  factory LazyGivingRequest.fromJson(Map<String, dynamic> json) =>
      _$LazyGivingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LazyGivingRequestToJson(this);

}