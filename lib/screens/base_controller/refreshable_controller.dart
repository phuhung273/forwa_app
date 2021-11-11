
import 'base_controller.dart';

abstract class RefreshableController extends BaseController{

  Future main();

  @override
  Future onReady() async {
    super.onReady();

    showLoadingDialog();
    await main();
    hideDialog();
  }
}