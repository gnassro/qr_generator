import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrgenerator/tools/colors.dart';


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
  String? inputTextToGenerate;
  Uint8List? pngBytes;

  bool? gapState;
  InputCompo textField = InputCompo();
  BodyCompo qrBody = BodyCompo();
  double? imageSIze;

  @override
  void initState() {
    super.initState();
    inputTextToGenerate = "";
    gapState = false;
    imageSIze = 500.0;
  }

  @override
  void dispose() {
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
            ],
          ),
        ),
      bottomSheet: BodyCompo().downloadLayout(
        context: context,
        pressedDownload: () {
          setState(() {
            _capturePng(inputTextToGenerate,imageSize: imageSIze!);
          });
        },
        selectedSize: (size) {
          imageSIze = size;
        }
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