import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/weather_data/weather_data.dart';
import '../utils/size_config.dart';

class WeatherCard extends StatelessWidget {
  // this is the widget I extracted so that I can use it in multiple places
  WeatherCard({required this.weatherData});

  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Padding(
      padding: EdgeInsets.all(defaultSize *
          2), // 20 padding externally ternally to separate the Cards from each other
      child: SizedBox(
        width: defaultSize *
            33.5, // making the sizedBox of width 205 (10 * 20.5 = 205) and at the same time we are providing it responsive width
        child: AspectRatio(
          aspectRatio:
              1.025, //aspectRatio: 0.83 means that the width of the widget is 0.83 times the height resulting in a slightly wider and shorter widget compared to a perfect square.
          // Let's say the height of the widget is 100 units. In that case, the width will be calculated as 0.83 times the height, which is 0.83 * 100 = 83 units. So, the widget will have a width of 83 units and a height of 100 units, maintaining the specified aspect ratio.
          child: Stack(
            alignment: Alignment
                .bottomCenter, // This property will take only the smaller container to the bottom because the bigger one has already covered all space
            children: <Widget>[
              ClipPath(
                // This is Custom Shape that's why we need to use ClipPath
                clipper: CategoryCustomShape(), // for creating the clip design
                child: AspectRatio(
                    aspectRatio:
                        1.025, // taking a little smaller container in the stack
                    child: Container(
                        padding: EdgeInsets.all(defaultSize * 1.2),
                        color: Colors.indigo,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${weatherData.temperature.toStringAsFixed(2)}°C',
                                    style: GoogleFonts.rubik(
                                        color: Colors.white, fontSize: 40),
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  Text(
                                    weatherData.description,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[400],
                                      fontSize: 19,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-dd')
                                        .format(weatherData.date.toLocal()),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 21),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    weatherData.cityName,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  height: 65,
                                  width: 90,
                                  child: Image.network(
                                    weatherData.iconUrl,
                                    fit: BoxFit.cover,
                                  )),
                            ],
                          ),
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double width = size.width;
    double cornerSize = 30;

    path.lineTo(0, height - cornerSize);
    path.quadraticBezierTo(0, height, cornerSize, height);
    path.lineTo(width - cornerSize, height);
    path.quadraticBezierTo(width, height, width, height - cornerSize);
    path.lineTo(width, cornerSize);
    path.quadraticBezierTo(width, 0, width - cornerSize, 0);
    path.lineTo(cornerSize, cornerSize * 0.75);
    path.quadraticBezierTo(0, cornerSize, 0, cornerSize * 2);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
