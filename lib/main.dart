import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/splash/splash_screen_controller.dart';
import 'package:forwa_app/theme/theme.dart';
import 'package:forwa_app/widgets/dismissible_keyboard.dart';
import 'package:forwa_app/route/routing_observer.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'di/di.dart';

void main() async {
  await configureDependenciesBeforeFirebase();
  await Firebase.initializeApp();
  await FirebaseAnalytics.instance.logAppOpen();
  await configureDependenciesAfterFirebase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Forwa',
        theme: appTheme,
        initialBinding: SplashScreenBinding(),
        initialRoute: ROUTE_SPLASH,
        getPages: appRoute,
        defaultTransition: Transition.fade,
        transitionDuration: Get.defaultTransitionDuration,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routingCallback: RoutingObserver.observer,
      ),
    );
  }
}
