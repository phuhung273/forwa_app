import 'package:json_annotation/json_annotation.dart';

part 'stock_item.g.dart';

const DEFAULT_MAX_QUANTITY = 5;

@JsonSerializable()
class StockItem {

  @JsonKey(name: 'qty')
  int quantity;

  @JsonKey(name: 'is_in_stock')
  bool isInStock;

  StockItem({
    this.quantity = DEFAULT_MAX_QUANTITY,
    this.isInStock = true,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) =>
      _$StockItemFromJson(json);

  Map<String, dynamic> toJson() => _$StockItemToJson(this);

}