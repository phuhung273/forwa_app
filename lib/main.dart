import 'package:flutter/material.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/splash/splash_screen_controller.dart';
import 'package:forwa_app/theme/theme.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'di/di.dart';

Future main() async {
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
    );
  }
}
