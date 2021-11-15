import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorQrPicker {

  void showColorPicker ({
    required BuildContext? context,
    required void Function(Color) onColorChanged,
    required Color? pickedColor,
  }) {
    Color? colorToChange = pickedColor;
    showDialog(
      barrierDismissible: false,
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickedColor!,
              onColorChanged: (changedColor) {
                colorToChange = changedColor;
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  onColorChanged(colorToChange!);
                  Navigator.pop(context);
                } ,
                child: const Text("Pick")
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                } ,
                child: const Text("Cancel")
            )
          ],
        );
      },
    );
  }
}