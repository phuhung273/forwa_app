
import 'package:forwa_app/datasource/remote/customer_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/customer/customer.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class CustomerRepo extends BaseRepo {
  final CustomerService _service = Get.find();

  Future<ApiResponse<Customer>> myInfo() async {
    return _service.myInfo().then((value){
      return ApiResponse<Customer>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<Customer>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<Customer>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<Customer>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<Customer>> customerInfo(int customerId) async {
    return _service.customerInfo(customerId).then((value){
      return ApiResponse<Customer>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<Customer>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<Customer>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<Customer>.fromError(error: error);
      }
    });
  }
}