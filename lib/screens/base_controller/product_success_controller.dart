import 'dart:async';

class ProductSuccessController {

  final _productSuccessStreamController = StreamController<int>.broadcast();

  Stream<int> get productSuccessStream => _productSuccessStreamController.stream.cast<int>();

  void updateToSuccess(int id){
    _productSuccessStreamController.sink.add(id);
  }
}