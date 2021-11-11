import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:qrgenerator/tools/colors.dart';

class BodyCompo {
  final Color? _buttonColor = HexColor().buttonBackgroundColor();
  Widget switchQR ({required bool status, void Function(bool)? onToggle}) {

    return FlutterSwitch(
      activeColor: _buttonColor!,
      width: 125.0,
      height: 55.0,
      valueFontSize: 15.0,
      toggleSize: 45.0,
      value: status,
      borderRadius: 30.0,
      padding: 8.0,
      inactiveText: "Gap OFF",
      activeText: "Gap ON",
      showOnOff: true,
      onToggle: (val) {
        onToggle!(val);
      },
    );
  }

  Widget qrBuild(String? textToGenerate, bool gapless) {
    if (textToGenerate != "") {
      return Center(
        child: QrImage(
          backgroundColor: Colors.white,
          size: 300,
          data: textToGenerate!,
          version: QrVersions.auto,
          gapless: !gapless,
        ),
      );
    } else {
      return Center(
        child: QrImage(
          backgroundColor: Colors.white,
          size: 300,
          data: "testQR",
          version: QrVersions.auto,
          gapless: !gapless,
        ),
      );
    }
    return const Text("");
  }
}