
import 'package:flutter/foundation.dart';
import 'package:forwa_app/datasource/remote/order_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/order/create_order_request.dart';
import 'package:forwa_app/schema/order/list_orders_of_product_response.dart';
import 'package:forwa_app/schema/order/list_orders_of_product_response.dart';
import 'package:forwa_app/schema/order/list_orders_of_product_response.dart';
import 'package:forwa_app/schema/order/list_orders_of_product_response.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

const errorCodeMap = {
  'ORDER_001': 'Bạn đã xin món này rồi!',
  'ORDER_002': 'Lời nhắn quá ngắn!',
};

class OrderRepo extends BaseRepo{
  final OrderService _service = Get.find();

  Future<ApiResponse<Order>> createOrder(CreateOrderRequest request) async {
    return _service.createOrder(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<Order>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<Order>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<Order>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<List<Order>>> getMyOrders(
      {
        int pageSize = 10,
      }
  ) async {
    return _service.getMyOrders().catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<List<Order>>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<List<Order>>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<List<Order>>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<String>> selectOrder(int orderId) async {
    return _service.selectOrder(orderId).then((value){
      return ApiResponse<String>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<String>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<String>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<String>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<ListOrdersOfProductResponse>> getOrdersOfProductId(
    int productId,
    {
      int pageSize = 10,
    }
  ) async {
    return _service.getOrdersOfProductId(productId).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<ListOrdersOfProductResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<ListOrdersOfProductResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<ListOrdersOfProductResponse>.fromError(error: error);
      }
    });
  }
}