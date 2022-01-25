import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:get/get.dart';

class RoutingObserver {

  static observer(Routing? routing) {
    /// You can listen in addition to the routes, the snackbars, dialogs and bottomsheets on each screen.
    ///If you need to enter any of these 3 events directly here,
    ///you must specify that the event is != Than you are trying to do.
    if(routing == null) return;

    final AnalyticService _analyticService = Get.find();

    if (!routing.isBottomSheet! && !routing.isDialog! && routing.current != ROUTE_MAIN) {
      _analyticService.setCurrentScreen(routing.current);
    }
  }
}