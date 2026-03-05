import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:weather_mine/res/routes/app_routes.dart';
import 'package:weather_mine/res/routes/rout_names.dart';
import 'package:get_storage/get_storage.dart';
Future<void> main() async {
// 1. Start the Flutter Engine
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Connect with Storage
  await GetStorage.init();

  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "OpenWeather Clone",
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesNames.homeView,
      getPages: AppRoutes.appRoutes(),
    );
  }
}

