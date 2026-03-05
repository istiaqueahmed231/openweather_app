


import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:weather_mine/res/routes/rout_names.dart';
import 'package:weather_mine/views/home_view.dart';

import '../../views/splash_view.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(
      name: RoutesNames.splashView,
      page: () =>  SplashView(),
      transition: Transition.fadeIn, // Adds a smooth feel
    ),
    GetPage(
      name: RoutesNames.homeView,
      page: () => HomeView(),
      transition: Transition.rightToLeftWithFade,
    ),


  ];
}