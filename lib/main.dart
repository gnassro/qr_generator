import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrgenerator/tools/colors.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

import 'components/inputcompo.dart';
import 'components/bodycompo.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'QR Generator',
      home: QrGenerateApp(),
    );
  }
}


class QrGenerateApp extends StatefulWidget {
  const QrGenerateApp({Key? key}) : super(key: key);

  @override
  _QrGenerateAppState createState() => _QrGenerateAppState();
}

class _QrGenerateAppState extends State<QrGenerateApp> {
  final myController = TextEditingController();
  String? inputTextToGenerate;
  Uint8List? pngBytes;

  bool? gapState;
  InputCompo textField = InputCompo();
  BodyCompo qrBody = BodyCompo();

  @override
  void initState() {
    super.initState();
    inputTextToGenerate = "";
    gapState = false;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color? _appBackgroundColor = HexColor().appBackgroundColor();

    return Scaffold(
      backgroundColor: _appBackgroundColor,
      body: Center(
          child: ListView(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              textField.builder(
                controller: myController,
                onChanged: (text) {
                  setState(() {
                    inputTextToGenerate = text;
                  });
                }
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              qrBody.switchQR(
                  status: gapState!,
                  onToggle: (state) {
                    setState(() {
                      gapState = state;
                    });
                  }
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              qrBody.qrBuild(inputTextToGenerate!,gapState!),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _capturePng(inputTextToGenerate);
                    });
                  },
                  child: const Text("Download")),
            ],
          ),
        ),
    );
  }

  Future<void> _capturePng(String? textToGenerate, {double imageSize = 100}) async {
    try {
      var permStatus = await Permission.storage.status;
      if (!permStatus.isGranted) {
        await Permission.storage.request();
      }

      if(!permStatus.isDenied) {
        final image = await QrPainter(
            data: textToGenerate!,
            version: QrVersions.auto,
            gapless: false
        ).toImageData(imageSize);

        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png').create();
        await imagePath.writeAsBytes(image!.buffer.asUint8List());

        await ImageGallerySaver.saveFile(imagePath.path);
      }

    } catch (e) {
      rethrow;
    }
  }


}