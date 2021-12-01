import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:qrgenerator/library/global_colors.dart' as global_colors;
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:qrgenerator/tools/color_picker.dart';

class BodyCompo {
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

  Widget downloadLayout({required BuildContext context, required void Function(Color?, Color?)? pressedDownload, SolidController? controller, void Function(double)? selectedSize, Color? defaultQrColor = global_colors.blackColor, Color? defaultBackgroundQrColor = global_colors.whiteColor}) {
    Color? qrColor = defaultQrColor;
    Color? backgroundQrColor = defaultBackgroundQrColor;
    return SolidBottomSheet(
      controller: controller!,
      draggableBody: true,
      toggleVisibilityOnTap: true,
      headerBar: GestureDetector(
        onTap: () {
          //FocusScope.of(context).unfocus();
          if (controller.isOpened) {
            controller.hide();
          } else {
            controller.show();
          }
        },
        child: Container(
          color: global_colors.elementBackgroundColor!,
          height: 50,
          child: const Center(
            child: Text(
              "Download",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(global_colors.elementBackgroundColor), foregroundColor: MaterialStateProperty.all(global_colors.whiteColor)),
                        onPressed: () {
                          ColorQrPicker().showColorPicker(
                              context: context,
                              pickedColor: qrColor,
                              onColorChanged: (color) {
                                qrColor = color;
                              });
                        },
                        child: const Text('QR Color')),
                  ),
                ),
                Expanded(
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(global_colors.elementBackgroundColor), foregroundColor: MaterialStateProperty.all(global_colors.whiteColor)),
                        onPressed: () {
                          ColorQrPicker().showColorPicker(
                              context: context,
                              pickedColor: backgroundQrColor,
                              onColorChanged: (color) {
                                backgroundQrColor = color;
                              });
                        },
                        child: const Text('Background Color')),
                  ),
                )
              ],
            ),
            CustomRadioButton(
              enableShape: true,
              elevation: 0,
              spacing: 2.0,
              enableButtonWrap: true,
              absoluteZeroSpacing: false,
              selectedBorderColor: global_colors.primaryColor!,
              unSelectedBorderColor: global_colors.primaryColor!,
              unSelectedColor: global_colors.appBackgroundColor!,
              buttonLables: const [
                '100x',
                '500x',
                '1000x'
              ],
              buttonValues: const [
                '100',
                '500',
                '1000'
              ],
              defaultSelected: '500',
              buttonTextStyle: const ButtonTextStyle(selectedColor: Colors.white, unSelectedColor: Colors.black, textStyle: TextStyle(fontSize: 16)),
              radioButtonValue: (value) {
                selectedSize!(double.parse(value.toString()));
              },
              selectedColor: global_colors.elementBackgroundColor!,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: global_colors.primaryColor!,
                  padding: const EdgeInsets.all(35.0),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.6, MediaQuery.of(context).size.width * 0.6),
                  shape: const CircleBorder(),
                  side: BorderSide(width: 6.0, color: global_colors.elementBackgroundColor!),
                ),
                onPressed: () {
                  pressedDownload!(qrColor, backgroundQrColor);
                },
                child: Column(
                  children: const [
                    Icon(
                      Icons.downloading_sharp,
                      size: 100.0,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
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
