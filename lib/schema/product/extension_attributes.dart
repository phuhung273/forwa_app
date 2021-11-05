import 'package:json_annotation/json_annotation.dart';

import 'stock_item.dart';

part 'extension_attributes.g.dart';

@JsonSerializable()
class ExtensionAttributes {

  @JsonKey(name: 'website_ids')
  List<int>? websiteIds;

  @JsonKey(name: 'stock_item')
  StockItem? stockItem;

  @JsonKey(name: 'base_image_urls')
  List<String>? imageUrls;

  @JsonKey(name: 'quantity')
  int? quantity;

  @JsonKey(name: 'seller_name')
  String? sellerName;

  @JsonKey(name: 'is_disabled')
  bool? isDisabled;

  ExtensionAttributes({
    this.websiteIds,
    this.stockItem,
    this.imageUrls,
    this.quantity,
    this.sellerName,
    this.isDisabled,
  });

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      _$ExtensionAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionAttributesToJson(this);

}