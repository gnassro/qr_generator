import 'package:flutter/material.dart';
import 'package:qrgenerator/library/global_colors.dart' as global_colors;
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:qrgenerator/tools/color_picker.dart';


class DownloadComponent extends StatefulWidget {
  const DownloadComponent({
    Key? key,
    this.qrColor,
    this.backgroundQrColor
  }) : super(key: key);

  final Color? qrColor;
  final Color? backgroundQrColor;
  @override
  _QrDownloadAppState createState() => _QrDownloadAppState();
}

class _QrDownloadAppState extends State<DownloadComponent> {
  String? inputTextToGenerate;
  Color? qrColor,backgroundQrColor;

  @override
  void initState() {
    super.initState();
    qrColor = widget.qrColor;
    backgroundQrColor = widget.backgroundQrColor;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                              setState(() {
                                qrColor = color;
                              });
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
                              setState(() {
                                backgroundQrColor = color;
                              });
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
    );
  }
}