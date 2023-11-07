import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_api_implementation/models/weather_data/weather_data.dart';

import '../../services/weather_api_service/weather_api_service.dart';

class WeatherForecastController extends GetxController {
  final api = WeatherApiService(); // This is the instance of the 'WeatherApiService' class, which will be used to fetch weather data from an the API by calling the fetchWeatherData(city), function.
  var currentDayWeatherData = <WeatherData>[].obs;
  var otherDaysWeatherData = <WeatherData>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  void fetchWeatherData(String city) async {
    isLoading.value = true;
    error.value = '';

    try {
      final weatherDataMap = await api.fetchWeatherData(city);
      currentDayWeatherData.value = weatherDataMap['currentDay'] ?? [];
      otherDaysWeatherData.value = weatherDataMap['otherDays'] ?? [];
    } catch (e) {
      if (e is Exception) {
        error.value = 'Failed to load weather data: $e';
      } else {
        error.value = 'Failed to load weather data: An unknown error occurred.';
      }
    } finally {
      isLoading.value = false;
    }
  }
}
