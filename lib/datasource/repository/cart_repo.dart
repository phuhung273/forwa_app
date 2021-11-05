
import 'package:forwa_app/datasource/remote/cart_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/cart/add_cart_request.dart';
import 'package:forwa_app/schema/cart/cart_item.dart';
import 'package:dio/dio.dart';
import 'package:forwa_app/schema/cart/list_cart_customers_response.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

const DEFAULT_ORDER_QUANTITY = 1;

class CartRepo extends BaseRepo{


  final CartService _service = Get.find();

  Future<ApiResponse<String>> addToOrder(String sku, String message) async {
    final request = AddCartRequest(
      cartItem: CartItem(sku: sku, quantity: DEFAULT_ORDER_QUANTITY),
      message: message,
    );

    return _service.addToOrder(request).then((value){
      return ApiResponse<String>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<String>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<String>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<String>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<ListCartCustomersResponse>> getCustomersOfProduct(int productId) async {
    return _service.getCustomersOfProduct(productId).then((value){
      return ApiResponse<ListCartCustomersResponse>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<ListCartCustomersResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<ListCartCustomersResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<ListCartCustomersResponse>.fromError(error: error);
      }
    });
  }
}