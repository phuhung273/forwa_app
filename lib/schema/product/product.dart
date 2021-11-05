import 'package:forwa_app/datasource/remote/product_service.dart';
import 'package:json_annotation/json_annotation.dart';

import 'custom_attribute.dart';
import 'extension_attributes.dart';
import 'media_gallery_entry.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'sku')
  String? sku;

  @JsonKey(name: 'attribute_set_id')
  int? attributeSetId;

  @JsonKey(name: 'price')
  double? price;

  @JsonKey(name: 'type_id')
  String? typeId;

  @JsonKey(name: 'created_at')
  DateTime? createdAt;

  @JsonKey(name: 'extension_attributes')
  ExtensionAttributes? extensionAttributes;

  @JsonKey(name: 'custom_attributes')
  List<CustomAttribute>? customAttributes;

  @JsonKey(name: 'media_gallery_entries')
  List<MediaGalleryEntry>? medias;

  Product({
    this.id,
    required this.name,
    this.sku,
    this.attributeSetId = 4,
    this.price = 0,
    this.typeId = 'simple',
    this.createdAt,
    this.extensionAttributes,
    this.customAttributes,
    this.medias,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  String? get firstImageUrl {
    if(extensionAttributes == null || extensionAttributes!.imageUrls == null || extensionAttributes!.imageUrls!.isEmpty) return null;
    return extensionAttributes!.imageUrls!.first;
  }

  int? get quantity {
    if(extensionAttributes == null) return null;
    return extensionAttributes!.quantity;
  }

  String? get sellerName {
    if(extensionAttributes == null) return null;
    return extensionAttributes!.sellerName;
  }

  List<String>? get images {
    if(extensionAttributes == null) return null;
    return extensionAttributes!.imageUrls;
  }

  int? get websiteId {
    if(extensionAttributes == null) return null;
    return extensionAttributes!.websiteIds!.firstWhere((element) => element != DEFAULT_WEBSITE_ID);
  }

  bool get isDisabled {
    if(extensionAttributes == null) return true;
    return extensionAttributes!.isDisabled!;
  }

  String? get description => _getCustomAttributeByCode(CustomAttributeCode.DESCRIPTION);

  String? get pickupTime => _getCustomAttributeByCode(CustomAttributeCode.PICKUP_TIME);

  String? _getCustomAttributeByCode(CustomAttributeCode code){
    if(customAttributes == null) return null;
    return customAttributes?.firstWhere(
            (element) => element.attributeCode == CustomAttribute.getCode(code)
    ).value;
  }
}