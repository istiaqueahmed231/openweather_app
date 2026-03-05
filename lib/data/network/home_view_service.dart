import 'package:http/http.dart' as http;

import '../../res/app_url/api_url.dart';


class HomeViewService {

  // Accept lat and lon as parameters
  Future<http.Response> fetchWeatherApi(double lat, double lon) async {

    // build the complete URL using your ApiUrl class
    String url = ApiUrl.getWeatherUrl(lat, lon);

    try {
      // make the network request
      http.Response response = await http.get(Uri.parse(url));

      return response;
      print(response);

    } catch (e) {
      // 4. Catch any network drops or errors so your app doesn't crash
      throw Exception("Failed to fetch weather data: $e");
    }
  }



}