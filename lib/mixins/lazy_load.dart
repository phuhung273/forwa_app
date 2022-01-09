import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

mixin LazyLoad {

  final int stepToLoad = 3;
  int get listLength;
  bool _isLoading = false;
  bool _stop = false;

  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  void initLazyLoad() {
    itemPositionsListener.itemPositions.addListener(() async {
      final positions = itemPositionsListener.itemPositions.value;
      if(positions.last.index + stepToLoad >= listLength && !_isLoading && listLength != 0 && !_stop){
        _isLoading = true;
        print('Init lazyload');
        await onLazyLoad();
        _isLoading = false;
      }
    });
  }

  Future onLazyLoad();

  void stopLazyLoad() => _stop = true;
  void resetLazyLoad() => _stop = false;
}