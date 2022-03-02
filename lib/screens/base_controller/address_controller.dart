import 'dart:async';

import 'package:forwa_app/schema/address/address.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  final _editAddressController = StreamController<Address>.broadcast();

  Stream<Address> get editAddressStream => _editAddressController.stream.cast<Address>();

  emitEditAddressEvent(Address address){
    _editAddressController.sink.add(address);
  }
}