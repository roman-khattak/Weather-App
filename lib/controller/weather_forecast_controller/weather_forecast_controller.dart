import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_api_implementation/models/weather_data/weather_data.dart';

import '../../services/weather_api_service/weather_api_service.dart';
import '../../utils/user_shared_preferences.dart';

class WeatherForecastController extends GetxController {
  final api =
      WeatherApiService(); // This is the instance of the 'WeatherApiService' class, which will be used to fetch weather data from an the API by calling the fetchWeatherData(city), function.
  var currentDayWeatherData = <WeatherData>[].obs;
  var otherDaysWeatherData = <WeatherData>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  RxString lastCity = ''.obs;
  final TextEditingController textController = TextEditingController();
  UserSharedPreferences userSharedPreferences =
      Get.find<UserSharedPreferences>();

  Future<void> saveLastCity(String city) async {
    lastCity.value = city; // Update the reactive variable
    debugPrint("LASTCITY SAVED: $city");
    await userSharedPreferences.saveLastCity(city);
    textController.text = city;
  }

  Future<void> loadLastCity() async {
    lastCity.value = await userSharedPreferences.getLastCity();
    fetchWeatherData(lastCity.value);
  }

  void fetchWeatherData(String city) async {
    isLoading.value = true;
    error.value = '';

    try {
      final weatherDataMap = await api.fetchWeatherData(city);
      currentDayWeatherData.value = weatherDataMap['currentDay'] ?? [];
      otherDaysWeatherData.value = weatherDataMap['otherDays'] ?? [];
    } on SocketException {
      error.value = 'No internet connection. Please check your connection.';
    } catch (e) {
      debugPrint('Error in WeatherForecastFetching: $e');
      if (e is Exception) {
        error.value = e.toString().contains('City not found')
            ? 'City not found. Please try another city.'
            : 'Failed to load weather data: $e';
      } else {
        error.value = 'Failed to load weather data: An unknown error occurred.';
      }
    } finally {
      isLoading.value = false;
    }
  }
}
