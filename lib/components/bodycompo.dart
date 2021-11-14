import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:qrgenerator/tools/colors.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class BodyCompo {
  final Color? _buttonColor = HexColor().buttonBackgroundColor();
  final Color? _layoutBackground = HexColor().appBackgroundColor();
  final Color? _primary = HexColor().primaryTextColor();


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
  }

  Widget downloadLayout({required BuildContext context, required void Function()? pressedDownload, void Function(double)? selectedSize}) {
    return SolidBottomSheet(
      toggleVisibilityOnTap: true,
        headerBar: Container(
          color: _buttonColor,
          height: 50,
          child: const Center(
            child: Text(
                "Download",
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ),
        body:  Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              CustomRadioButton(
                enableShape: true,
                elevation: 0,
                spacing: 2.0,
                enableButtonWrap: true,
                absoluteZeroSpacing: false,
                selectedBorderColor: _primary,
                unSelectedBorderColor: _primary,
                unSelectedColor: _layoutBackground!,
                buttonLables: const ['100x','500x','1000x'],
                buttonValues: const ['100','500','1000'],
                defaultSelected: '500',
                buttonTextStyle: const ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Colors.black,
                    textStyle: TextStyle(fontSize: 16)),
                radioButtonValue: (value) {
                  selectedSize!(double.parse(value.toString()));
                },
                selectedColor: _buttonColor!,
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: _primary,
                    padding: const EdgeInsets.all(35.0),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.6,MediaQuery.of(context).size.width * 0.6),
                    shape: const CircleBorder(),
                    side: BorderSide(
                        width: 6.0,
                      color: _buttonColor!
                    ),
                  ),
                  onPressed: () {
                    pressedDownload!();
                    _showSnackBar(
                        context: context,
                      message: "taped"
                    );
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.downloading_sharp,
                        size: 100.0,
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
    );
  }

  void _showSnackBar ({required BuildContext context, String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black87,
          content: GestureDetector(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children : [
                  Expanded(
                      flex: 1,
                      child: Text(
                          message!,
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      )
                  )
                ]
            ),
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
          duration: const Duration(seconds: 3),
        )
    );
  }
}