
import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/schema/image/image.dart';
import 'package:forwa_app/schema/product/product_detail.dart';
import 'package:forwa_app/schema/user/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'product.g.dart';

enum ProductStatus {
  PROCESSING,
  SELECTED,
  FINISH,
  CANCEL,
}

@JsonSerializable()
class Product{

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'sku')
  String sku;

  @JsonKey(name: 'status')
  String? statusString;

  @JsonKey(name: 'created_at')
  DateTime? createdAt;

  @JsonKey(name: 'latitude')
  String? latitude;

  @JsonKey(name: 'longitude')
  String? longitude;

  @JsonKey(name: 'ward_latitude')
  String? wardLatitude;

  @JsonKey(name: 'ward_longitude')
  String? wardLongitude;

  @JsonKey(name: 'images')
  List<Image>? images;

  @JsonKey(name: 'user')
  User? user;

  @JsonKey(name: 'address')
  Address? address;

  @JsonKey(name: 'detail')
  ProductDetail? detail;

  @JsonKey(name: 'enabled')
  bool? enabled;

  @JsonKey(name: 'orders_count')
  int? orderCount;

  Product({
    this.id,
    required this.name,
    required this.sku,
    this.createdAt,
    this.images,
    this.latitude,
    this.longitude,
    this.user,
    this.address,
    this.detail,
    this.enabled,
    this.orderCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  String? get firstImageUrl => images?.first.url;

  int? get quantity => detail?.quantity;

  String? get sellerName => user?.name;

  String? get description => detail?.description;

  String? get pickupTime => detail?.pickupTime;

  LatLng? get location {
    if(latitude == null && longitude == null) return null;
    return LatLng(double.tryParse(latitude!)!, double.tryParse(longitude!)!);
  }

  LatLng? get wardLocation {
    if(wardLatitude == null && wardLongitude == null) return null;
    return LatLng(double.tryParse(wardLatitude!)!, double.tryParse(wardLongitude!)!);
  }

  DateTime? get dueDate {
    if(detail?.dueDate == null) return null;
    return DateTime.parse(detail!.dueDate!);
  }

  ProductStatus? get status => statusString != null
      ? EnumToString.fromString(ProductStatus.values, statusString!.toUpperCase())
      : null;

  bool get haveOrders => orderCount != null && orderCount! > 0;
}