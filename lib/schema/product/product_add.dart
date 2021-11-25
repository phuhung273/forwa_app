import 'dart:io';

class ProductAdd {
  String name;
  String sku;
  String description;
  int quantity;
  String pickupTime;
  List<File> images;

  ProductAdd({
    required this.name,
    required this.sku,
    required this.quantity,
    required this.description,
    required this.pickupTime,
    required this.images,
  });
}