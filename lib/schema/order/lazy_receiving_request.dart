import 'package:json_annotation/json_annotation.dart';

part 'lazy_receiving_request.g.dart';

@JsonSerializable()
class LazyReceivingRequest {

  @JsonKey(name: 'take')
  int take;

  @JsonKey(name: 'low_id')
  int lowId;

  LazyReceivingRequest({
    this.take = 10,
    required this.lowId,
  });

  factory LazyReceivingRequest.fromJson(Map<String, dynamic> json) =>
      _$LazyReceivingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LazyReceivingRequestToJson(this);

}