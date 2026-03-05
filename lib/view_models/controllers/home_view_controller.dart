import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';


import 'package:weather_mine/models/weather_model.dart';

import '../../repository/home_view_repository.dart';

class HomeViewController extends GetxController {
  // --- Observables (State) ---
  var isLoading = true.obs;

  // Header Info
  var cityName = "Locating...".obs;
  var currentDate = "Today".obs;

  // Main Weather Info
  var currentTemp = 0.obs;
  var weatherCondition = "--".obs;

  // Weather Details
  var highTemp = 0.obs;
  var lowTemp = 0.obs;
  var humidity = 0.obs;
  var windSpeed = 0.obs;
  var rainChance = 0.obs;

  // Store the full model in case you need other data (like hourly/daily lists) later
  var weatherData = Rxn<WeatherModel>();

  // --- Dependencies ---
  final HomeViewRepository _repository = HomeViewRepository();

  @override
  void onInit() {
    super.onInit();
    _setTodayDate();
    _getUserLocation();
  }

  // Set a simple readable date format
  void _setTodayDate() {
    DateTime now = DateTime.now();
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    currentDate.value = "${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}";
  }

  // 1. Start Location Process
  Future<void> _getUserLocation() async {
    isLoading(true);
    try {
      Position position = await _determinePosition();
      print("Lat: ${position.latitude}, Lon: ${position.longitude}");

      // Once we have coordinates, call the API!
      fetchWeatherFromApi(position.latitude, position.longitude);
      _getCityName(position.latitude, position.longitude);

    } catch (e) {
      Get.snackbar(
        "Location Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1A3E7A).withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
      isLoading(false);
    }
  }

  // 2. Handle GPS & Permissions (Geolocator)
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled. Please turn on your GPS.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied. Please enable them in settings.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // 3. Fetch Data from Repository and Map to Model
  void fetchWeatherFromApi(double lat, double lon) async {
    try {
      print("🌍 Attempting to fetch weather for Lat: $lat, Lon: $lon...");

      var response = await _repository.getWeatherData(lat, lon);

      if (response.statusCode == 200) {
        print("✅ API SUCCESS! Here is the exact JSON from OpenWeatherMap:");

        // THIS prints the massive JSON string exactly like Postman shows it
        print(response.body);

        var decodedJson = jsonDecode(response.body);
        WeatherModel fetchedWeather = WeatherModel.fromJson(decodedJson);
        weatherData.value = fetchedWeather;

        currentTemp.value = fetchedWeather.current?.temp?.round() ?? 0;
        humidity.value = fetchedWeather.current?.humidity?.round() ?? 0;
        windSpeed.value = fetchedWeather.current?.windSpeed?.round() ?? 0;

        if (fetchedWeather.current?.weather != null && fetchedWeather.current!.weather!.isNotEmpty) {
          weatherCondition.value = fetchedWeather.current!.weather![0].description ?? "Unknown";
        }

      } else {
        // If the URL is malformed or the key is wrong, this will tell you exactly why
        print("❌ API ERROR - Status Code: ${response.statusCode}");
        print("❌ Reason: ${response.body}");
      }
    } catch (e) {
      print("🚨 NETWORK OR PARSING CRASH: $e");
    } finally {
      isLoading(false);
    }
  }




// ... inside your HomeViewController ...

  // 1. Add this new function to translate the coordinates
  Future<void> _getCityName(double lat, double lon) async {
    try {
      // This fetches a list of possible addresses for the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // place.locality usually holds the City (e.g., "Comilla" or "Dhaka")
        // place.country holds the Country (e.g., "Bangladesh")
        cityName.value = "${place.locality}, ${place.country}";
        print("📍 City found: ${cityName.value}");
      }
    } catch (e) {
      print("Error fetching city name: $e");
      cityName.value = "Unknown Location";
    }
  }
}