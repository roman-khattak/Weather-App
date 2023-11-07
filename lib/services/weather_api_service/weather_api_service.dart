import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/weather_data/weather_data.dart';

class WeatherApiService {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';
  final String apiKey = 'deecf926acc654b1455d1c20d268f636';

  Future<Map<String, List<WeatherData>>> fetchWeatherData(String city) async {   // The object returned is "weatherDataMap" whose data type is 'Map<String, List<WeatherData>>' therefore, the return type here is set according to that.
    final Uri uri = Uri.parse('$baseUrl?q=$city&appid=$apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<WeatherData> currentDayWeatherList = [];
      final List<WeatherData> restOfDaysWeatherList = [];
      // 'currentDate' is a variable that keeps track of the date of the currently processed weather data, and it's initially 'null'.
      // This variable determines whether the data belongs to current day or another day
      DateTime? currentDate;

      for (var item in data['list']) {
        final date = DateTime.parse(item['dt_txt']);
        final description = item['weather'][0]['description'];
        final temperature = item['main']['temp'] - 273.15;
        final icon = item['weather'][0]['icon'];
        final iconUrl = 'http://openweathermap.org/img/w/$icon.png';

        if (currentDate == null || date.day != currentDate.day) {
          // The constructor "WeatherData(this.date, this.description, this.temperature, this.iconUrl)" initializes a new "WeatherData object". It takes the provided parameters and assigns them to the respective fields within the object for each item coming from API. This is a common approach to encapsulate data and create objects that represent specific entities in the application, such as 'weather' object in this case.
          final weather = WeatherData(date, description, temperature, iconUrl);
          if (currentDate == null) {   // If 'currentDate' variable is 'null', it means that this is the first weather data item being processed, so it sets 'currentDate' variable to the current/today's 'date'.
            currentDayWeatherList.add(weather);

          } else { // If 'currentDate' variable is not null, it means that there's already a date stored, and this new data item is for a different day. In this case, it adds the weather object to the 'restOfDaysWeatherList', which is created to store weather data for days other than the current day.
            restOfDaysWeatherList.add(weather);
          }
          currentDate = date;
        }
      }

      final Map<String, List<WeatherData>> weatherDataMap = {  //the code constructs a map called weatherDataMap, where the data is organized into two lists: 'currentDay' for today's data and 'otherDays' for the data for the rest of the days.
        'currentDay': currentDayWeatherList,
        'otherDays': restOfDaysWeatherList,
      };

      return weatherDataMap;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}