import 'package:weather_mine/utils/api_keys/opw_api_key.dart';

class ApiUrl {
  static const String apiKey = "a51004cd0e0640fc7d09e2089e86b80a";
  static const String baseUrl = "https://api.openweathermap.org/data/3.0/onecall";

  static String getWeatherUrl(double lat, double lon) {
    // We replace {part} with 'minutely' to keep the payload clean
    return "$baseUrl?lat=$lat&lon=$lon&exclude=minutely&appid=$apiKey&units=metric";
  }

}