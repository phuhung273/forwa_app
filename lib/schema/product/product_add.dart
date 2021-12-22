import 'dart:io';

class ProductAdd {
  String name;
  String sku;
  String description;
  int quantity;
  String pickupTime;
  String? dueDate;
  List<File> images;
  int addressId;

  ProductAdd({
    required this.name,
    required this.sku,
    required this.quantity,
    required this.description,
    required this.pickupTime,
    this.dueDate,
    required this.images,
    required this.addressId,
  });
}