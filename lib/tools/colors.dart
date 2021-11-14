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
    return const Color(0xffF1F7F8);
  }

  Color buttonBackgroundColor() {
    return const Color(0xff438DA9);
  }

  Color primaryTextColor() {
    return const Color(0xff05668D);
  }
  Color primaryTextColorFaded() {
    return const Color(0xffBFD9E1);
  }

  Color whiteColor() {
    return const Color(0xffffffff);
  }
}