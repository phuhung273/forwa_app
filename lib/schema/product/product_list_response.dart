import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'product_list_response.g.dart';

@JsonSerializable()
class ProductListResponse {

  @JsonKey(name: 'data')
  List<Product> items;

  ProductListResponse({
    required this.items,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListResponseToJson(this);

}