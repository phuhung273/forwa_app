import 'dart:async';

import 'package:forwa_app/schema/product/product.dart';
import 'package:get/get.dart';

class ProductController extends GetxController{

  final _editProductController = StreamController<Product>.broadcast();
  final _productSuccessStreamController = StreamController<int>.broadcast();

  Stream<Product> get editProductStream => _editProductController.stream.cast<Product>();
  Stream<int> get productSuccessStream => _productSuccessStreamController.stream.cast<int>();

  void updateToSuccess(int id){
    _productSuccessStreamController.sink.add(id);
  }

  emitEditProductEvent(Product product){
    _editProductController.sink.add(product);
  }
}