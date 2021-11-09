import 'package:json_annotation/json_annotation.dart';

part 'create_invoice_request.g.dart';

@JsonSerializable()
class CreateInvoiceRequest {

  @JsonKey(name: 'product_name')
  String productName;

  CreateInvoiceRequest({
    required this.productName,
  });

  factory CreateInvoiceRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateInvoiceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateInvoiceRequestToJson(this);

}