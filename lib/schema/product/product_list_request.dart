import 'package:json_annotation/json_annotation.dart';

part 'product_list_request.g.dart';

@JsonSerializable()
class ProductListRequest {

  @JsonKey(name: 'hidden_user_ids')
  List<int> hiddenUserIds;

  ProductListRequest({
    required this.hiddenUserIds,
  });

  factory ProductListRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListRequestToJson(this);

}