
import 'base_controller.dart';

abstract class AuthorizedRefreshableController extends BaseController{

  Future main();

  Future authorizedMain() async {
    if(!isAuthorized()) return;
    await main();
  }

  bool isAuthorized();

  @override
  Future<bool> onReady() async {
    super.onReady();

    if(!isAuthorized()){
      showLoginDialog();
      return false;
    }

    showLoadingDialog();
    await main();
    hideDialog();

    return true;
  }
}