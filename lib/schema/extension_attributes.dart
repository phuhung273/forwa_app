import 'package:forwa_app/schema/review/review.dart';
import 'package:json_annotation/json_annotation.dart';

import 'product/stock_item.dart';

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

  @JsonKey(name: 'seller_id')
  int? sellerId;

  @JsonKey(name: 'is_disabled')
  bool? isDisabled;

  @JsonKey(name: 'latitude')
  String? latitude;

  @JsonKey(name: 'longitude')
  String? longitude;

  @JsonKey(name: 'reviews')
  List<Review>? reviews;

  @JsonKey(name: 'rating')
  double? rating;

  ExtensionAttributes({
    this.websiteIds,
    this.stockItem,
    this.imageUrls,
    this.quantity,
    this.sellerName,
    this.sellerId,
    this.isDisabled,
    this.latitude,
    this.longitude,
    this.reviews,
    this.rating,
  });

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      _$ExtensionAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionAttributesToJson(this);

}