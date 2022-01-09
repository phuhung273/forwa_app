import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

mixin LazyLoad {

  int get stepToLoad => 3;
  int get listLength;
  bool _isLoading = false;
  bool _stop = false;

  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  void initLazyLoad() {
    itemPositionsListener.itemPositions.addListener(() async {
      if(_checkLazyCondition()){
        _isLoading = true;
        await onLazyLoad();
        _isLoading = false;
      }
    });
  }

  bool _checkLazyCondition(){
    final positions = itemPositionsListener.itemPositions.value;
    return positions.last.index + stepToLoad >= listLength // User almost reach end of list
      && !_isLoading // Lazy load is not fetching
      && listLength != 0 // list has been initialized
      && !_stop // has not been stop manually
      ;
  }

  Future onLazyLoad();

  void stopLazyLoad() => _stop = true;
  void resetLazyLoad() => _stop = false;
}