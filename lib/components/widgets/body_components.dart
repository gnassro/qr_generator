import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../libraries/global_colors.dart' as global_colors;

class BodyCompo {

  Widget inputBuilder ({
    required void Function(String)? onChanged,
  }) {
    return IntrinsicWidth(
        child: TextFormField(
          onChanged: (text) {onChanged!(text);},
          decoration:  InputDecoration(
              fillColor: global_colors.whiteColor!,
              filled: true,
              labelText: 'Text to Generate',
              labelStyle: const TextStyle(
                color: global_colors.primaryColor,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: global_colors.primaryFadedColor!,
                    width: 1
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: global_colors.primaryFadedColor!,
                    width: 1.8
                ),
              )
          ),
        )
    );
  }

  Widget switchQR({required bool status, void Function(bool)? onToggle}) {
    return FlutterSwitch(
      activeColor: global_colors.elementBackgroundColor!,
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
        child: Image.asset(
          'assets/images/emptyQr.png',
          width: 300,
          height: 300,
        ),
      );
    }
  }

  void showSnackBar({required BuildContext context, String? message, Color? backgroundColor = global_colors.blackColor}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: GestureDetector(
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              flex: 1,
              child: Text(
                message!,
                style: const TextStyle(color: Colors.white),
              ))
        ]),
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      duration: const Duration(seconds: 3),
    ));
  }
}