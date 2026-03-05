import 'package:weather_mine/data/network/home_view_service.dart';
import 'package:http/http.dart' as http;

class HomeViewRepository {
  final HomeViewService homeViewService = HomeViewService();

  // Accept the lat and lon from the Controller and pass them to the Service
  Future<http.Response> getWeatherData(double lat, double lon) async {
    // Call the instance method and pass the coordinates
    return await homeViewService.fetchWeatherApi(lat, lon);
  }
}