import 'package:flutter/material.dart';

class HexColor {

  Color getColorFromHex(String hexColor) {

    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Color appBackgroundColor() {
    return getColorFromHex('#F1F7F8');
  }

  Color buttonBackgroundColor() {
    return getColorFromHex('#438DA9');
  }

  Color primaryTextColor() {
    return getColorFromHex('#05668D');
  }
  Color primaryTextColorFaded() {
    return getColorFromHex('#BFD9E1');
  }

  Color whiteColor() {
    return getColorFromHex('#ffffff');
  }
}