import 'dart:io';

class ProductUpdate {
  String name;
  String description;
  String pickupTime;
  String? dueDate;
  List<File>? imageFiles;
  List<int>? imageIds;
  int addressId;

  ProductUpdate({
    required this.name,
    required this.description,
    required this.pickupTime,
    this.dueDate,
    this.imageFiles,
    this.imageIds,
    required this.addressId,
  });
}