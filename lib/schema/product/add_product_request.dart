import 'package:forwa_app/schema/product/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_product_request.g.dart';

@JsonSerializable()
class AddProductRequest {

  @JsonKey(name: 'product')
  Product product;

  AddProductRequest({
    required this.product,
  });

  factory AddProductRequest.fromJson(Map<String, dynamic> json) =>
      _$AddProductRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddProductRequestToJson(this);

}