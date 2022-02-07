import 'dart:async';

import 'package:forwa_app/schema/order/order.dart';

class OrderController {

  final _processingOrderStreamController = StreamController<Order>.broadcast();
  final _selectedOrderStreamController = StreamController<Order>.broadcast();

  Stream<Order> get processingOrderStream => _processingOrderStreamController.stream.cast<Order>();
  Stream<Order> get selectedOrderStream => _selectedOrderStreamController.stream.cast<Order>();

  receiveProcessingOrder(Order order){
    _processingOrderStreamController.sink.add(order);
  }

  receiveSelectedOrder(Order order){
    _selectedOrderStreamController.sink.add(order);
  }
}