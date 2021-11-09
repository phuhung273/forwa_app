
import 'package:forwa_app/datasource/remote/order_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/order/create_invoice_request.dart';
import 'package:forwa_app/schema/order/list_order_response.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class OrderRepo extends BaseRepo{
  final OrderService _service = Get.find();

  Future<ApiResponse<ListOrderResponse>> getOrdersOfCustomer(
      customerId,
      {
        int pageSize = 10,
      }
  ) async {
    return _getOrdersOfCustomer(
      customerId,
      pageSize: pageSize,
    ).then((value){
      return ApiResponse<ListOrderResponse>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<ListOrderResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<ListOrderResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<ListOrderResponse>.fromError(error: error);
      }
    });
  }


  Future<ListOrderResponse> _getOrdersOfCustomer(
    customerId,
    {
      pageSize = 10,
      fields = 'items[entity_id,status,items[name,sku,updated_at],extension_attributes[base_image_urls]]',
    }
  ) async {
    return _service.getOrdersOfCustomer(
      'customer_id',
      customerId,
      pageSize,
      fields,
    );
  }

  Future<ApiResponse<String>> createInvoice(int orderId, CreateInvoiceRequest request) async {
    return _service.createInvoice(orderId, request).then((value){
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
}