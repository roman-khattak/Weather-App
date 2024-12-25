import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/weather_data/weather_data.dart';

class WeatherApiService {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';
  final String apiKey = 'acf1e3390a7132765ca9a224268961ee';

  Future<Map<String, List<WeatherData>>> fetchWeatherData(String city) async {
    final Uri uri = Uri.parse('$baseUrl?q=$city&appid=$apiKey');
    try {
      final response = await http.get(uri);
      debugPrint("response is ${response.toString()}");

      if (response.statusCode == 200) {
        debugPrint("responsebody is ${response.body}");
        final data = json.decode(response.body);
        final cityName = data['city']['name']; // Access the city name
        final List<WeatherData> currentDayWeatherList = [];
        final List<WeatherData> restOfDaysWeatherList = [];
        DateTime? currentDate;
        for (var item in data['list']) {
          debugPrint("item: ${item['city']}");
          final date = DateTime.parse(item['dt_txt']);
          final description = item['weather'][0]['description'];
          final temperature = item['main']['temp'] - 273.15;
          final icon = item['weather'][0]['icon'];
          final iconUrl = 'http://openweathermap.org/img/w/$icon.png';

          if (currentDate == null || date.day != currentDate.day) {
            final weather = WeatherData(
              date,
              description,
              temperature,
              iconUrl,
              cityName,
            );
            if (currentDate == null) {
              currentDayWeatherList.add(weather);
            } else {
              restOfDaysWeatherList.add(weather);
            }
            currentDate = date;
          }
        }

        return {
          'currentDay': currentDayWeatherList,
          'otherDays': restOfDaysWeatherList,
        };
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception(
            'Failed to load weather data: ${response.reasonPhrase}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      debugPrint('Error fetching weather data: $e');
      rethrow; // Re-throwing the exception to handle it in the controller
    }
  }
}
