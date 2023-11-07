import 'package:flutter/material.dart';

class SizeConfig {

  // 'late' keyword is used so that flutter control knows that the variable will be initialized later

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    // So basically the code below works this way :  "if the screen is landscape so the height is smaller so we divide the screen height by 0.024 to get a small value so that that value
    // ... can be assigned to the icons and containers to adjust their size on landscape and in the same way if the device is in portrait so now its width is smaller so we divide it by the same value of 0.024
    // ... so that again we can get a small value and now on portrait the icons and containers can adjust according to the shortened width of the screen

    // On iPhone 11 the defaultSize = 10 almost in both landscape and portrait, i.e., "defaultSize = screenHeight * 0.024(landscape) = screenWidth * 0.024(portrait) == 10"
    // So if the screen size increase or decrease then our defaultSize also changes according to that due to the code below

    defaultSize = orientation == Orientation.landscape
        ? screenHeight * 0.024
        : screenWidth * 0.024;
  }
}
