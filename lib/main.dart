import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_api_implementation/views/weather_forecast_screen.dart';

import 'controller/weather_forecast_controller/weather_forecast_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final controller = WeatherForecastController();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.indigo[900],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.indigo,
          title: Text('5-Days Weather Forecast',style: GoogleFonts.montserrat(color: Colors.white),),
        ),
        body: WeatherForecastScreen(controller: controller),
      ),
    );
  }
}