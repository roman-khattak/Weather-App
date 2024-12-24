import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controller/weather_forecast_controller/weather_forecast_controller.dart';
import '../utils/size_config.dart';
import '../widgets/weather_card.dart';

class WeatherForecastScreen extends StatelessWidget {
  final WeatherForecastController controller;

  WeatherForecastScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Timer? debouncer;

    void debounce(VoidCallback action,
        {Duration duration = const Duration(milliseconds: 500)}) {
      if (debouncer?.isActive ?? false) {
        debouncer?.cancel();
      }
      debouncer = Timer(duration, action);
    }

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  onChanged: (city) {
                    debounce(() {
                      controller.fetchWeatherData(city);
                    });
                  },
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'Enter city name',
                      hintStyle: GoogleFonts.rubik(color: Colors.white),
                      border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                } else if (controller.currentDayWeatherData.isEmpty &&
                    controller.otherDaysWeatherData.isEmpty) {
                  return Center(
                      child: Text(
                    'Enter a city to get the forecast.',
                    style: TextStyle(color: Colors.white),
                  ));
                } else {
                  return Column(
                    children: [
                      Text(
                        "Today",
                        style: GoogleFonts.macondo(
                            color: Colors.white, fontSize: 20),
                      ),
                      if (controller.currentDayWeatherData.isNotEmpty) ...[
                        WeatherCard(
                            weatherData: controller.currentDayWeatherData[0]),
                        const SizedBox(height: 20),
                      ],
                      if (controller.otherDaysWeatherData.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.otherDaysWeatherData.length,
                            itemBuilder: (context, index) {
                              final weather =
                                  controller.otherDaysWeatherData[index];
                              return ListTile(
                                title: Text(
                                  '${weather.temperature.toStringAsFixed(2)}°C',
                                  style: GoogleFonts.rubik(
                                      color: Colors.white, fontSize: 25),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      weather.description,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[400],
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(weather.date.toLocal()),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ],
                                ),
                                leading: Image.network(weather.iconUrl),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                }
              }),
            ),
          ],
        ));
  }
}
