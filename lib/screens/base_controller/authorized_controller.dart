import 'package:forwa_app/screens/base_controller/base_controller.dart';

abstract class AuthorizedController extends BaseController{

  bool isAuthorized();

  @override
  Future onReady() async {
    super.onReady();

    if(!isAuthorized()){
      showLoginDialog();
      return;
    }
  }
}