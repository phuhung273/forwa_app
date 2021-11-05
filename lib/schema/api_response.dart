
class ApiResponse<T> {
  String? message;
  bool isSuccess;
  T? data;

  ApiResponse({
    this.message,
    this.isSuccess = true,
    this.data,
  });

  factory ApiResponse.fromError({String error = 'Lỗi không xác định'}){
    return ApiResponse(
      isSuccess: false,
      message: error,
    );
  }
}