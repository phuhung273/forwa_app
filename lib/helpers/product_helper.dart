
import 'package:random_string/random_string.dart';

String genSku(String storeCode){
  return '$storeCode-${randomAlphaNumeric(10)}';
}