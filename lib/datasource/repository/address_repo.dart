
import 'package:forwa_app/datasource/remote/address_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/address/create_address_request.dart';
import 'package:forwa_app/schema/address/customer_address_response.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class AddressRepo extends BaseRepo{

  final AddressService _service = Get.find();

  Future<ApiResponse<CustomerAddressResponse>> saveAddress(CreateAddressRequest request) async {
    return _service.saveAddress(request).then((value){
      return ApiResponse<CustomerAddressResponse>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<CustomerAddressResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<CustomerAddressResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<CustomerAddressResponse>.fromError(error: error);
      }
    });
  }
}