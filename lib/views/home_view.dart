import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_mine/res/colors/app_colors.dart';
import 'package:weather_mine/view_models/controllers/home_view_controller.dart';

class HomeView extends StatelessWidget {
  // Injecting the controller
  final HomeViewController controller = Get.put(HomeViewController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen height to calculate perfect spacing
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E5DAE), Color(0xFF6BAAFE)],
          ),
        ),
        child: SafeArea(
          bottom: false, // Let the bottom sheet go to the very bottom edge
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            return Stack(
              children: [
                // 1. Wrap the main content in a Positioned.fill and SingleChildScrollView
                Positioned.fill(
                  child: SingleChildScrollView(
                    // physics: const BouncingScrollPhysics(), // Optional: adds a nice bounce effect
                    child: Column(
                      children: [
                        // 2. Add explicit top padding to push the header down
                        const SizedBox(height: 20),
                        _buildHeader(),

                        const SizedBox(height: 30),
                        _buildMainWeather(),

                        const SizedBox(height: 30),
                        _buildWeatherDetails(),

                        const SizedBox(height: 30),
                        _buildHourlyForecast(),

                        // 3. Add a blank space at the bottom equal to the bottom sheet's initial height (approx 25-30% of screen)
                        // This prevents the bottom sheet from covering the hourly forecast!
                        SizedBox(height: screenHeight * 0.30),
                      ],
                    ),
                  ),
                ),

                // The Bottom Sheet
                _buildForecastSheet(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.cityName.value,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    controller.currentDate.value,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainWeather() {
    return Column(
      children: [
        const Icon(Icons.cloud_queue, size: 100, color: Colors.white),
        Obx(
          () => Text(
            "${controller.currentTemp.value}°",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 80,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Obx(
          () => Text(
            controller.weatherCondition.value,
            style: const TextStyle(color: Colors.white70, fontSize: 20),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => _tempInfo(
                "High : ${controller.highTemp.value}°C",
                Icons.arrow_upward,
              ),
            ),
            const SizedBox(width: 20),
            Obx(
              () => _tempInfo(
                "Low : ${controller.lowTemp.value}°C",
                Icons.arrow_downward,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tempInfo(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Icon(icon, size: 14, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3E7A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() => _detailItem("Humidity", "${controller.humidity.value}%")),
          Obx(() => _detailItem("Wind", "${controller.windSpeed.value} km/h")),
          Obx(() => _detailItem("Rain", "${controller.rainChance.value}%")),
        ],
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    // Keeping this static for the layout example, but you'd map over an observable list here
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 6,
        itemBuilder: (context, index) {
          bool isNow = index == 1;
          return Container(
            width: 60,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: isNow ? Colors.white.withOpacity(0.3) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: isNow ? Border.all(color: Colors.white30) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "13:00",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Icon(
                  Icons.wb_sunny,
                  color: Colors.orangeAccent,
                  size: 24,
                ),
                const Text(
                  "21°",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildForecastSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.25,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: 8,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }
              return ListTile(
                leading: const Text(
                  "Mon",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                title: Row(
                  children: [
                    const Icon(Icons.wb_cloudy, color: Colors.blue),
                    const SizedBox(width: 20),
                    const Text("26°C"),
                  ],
                ),
                trailing: const Text("Partly Cloudy"),
              );
            },
          ),
        );
      },
    );
  }
}
