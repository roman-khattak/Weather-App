import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controller/weather_forecast_controller/weather_forecast_controller.dart';
import '../utils/size_config.dart';
import '../utils/widgets/common_widgets/custom_primary_button.dart';
import '../utils/widgets/weather_card.dart';

class WeatherForecastScreen extends StatefulWidget {
  WeatherForecastScreen();

  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  final controller = WeatherForecastController();

  @override
  void initState() {
    super.initState();
    loadLastCity();
  }

  loadLastCity() async {
    debugPrint("initState called");
    await controller.loadLastCity();
  }

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
                  controller: controller.textController,
                  onChanged: (city) {
                    debounce(() {
                      controller.fetchWeatherData(city);
                      controller.saveLastCity(city);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomPrimaryButton(
                  height: 35,
                  width: 130,
                  title: "Clear",
                  textStyle: GoogleFonts.rubik(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                  borderRadius: 25,
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    controller.textController.clear(); // Clear the TextField
                    controller.currentDayWeatherData.clear();
                    controller.otherDaysWeatherData.clear();
                  },
                ),
                CustomPrimaryButton(
                  height: 35,
                  width: 130,
                  title: "Refresh",
                  textStyle: GoogleFonts.rubik(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                  borderRadius: 25,
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    debugPrint(
                        "controller.lastCity.value is  ${controller.lastCity.value}");
                    controller.fetchWeatherData(controller.lastCity.value);
                  },
                ),
              ],
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
                } else if (controller.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.error.value,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  );
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
