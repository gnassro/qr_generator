import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'QR Generator',
      home: MyCustomForm(),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  String? inputTextToGenerate;
  final _globalKey = GlobalKey();
  Uint8List? pngBytes;

  @override
  void initState() {
    super.initState();
    inputTextToGenerate = "";
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code'),
      ),
      body: Column(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: myController,
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  inputTextToGenerate = myController.text;
                });
              },
              child: const Text("Generate")),
          _generateQRImage(inputTextToGenerate),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _capturePng(inputTextToGenerate);
                });
              },
              child: const Text("Download")),
        ],
      ),
    );
  }

  Future<void> _capturePng(String? textToGenerate) async {
    try {
      var permStatus = await Permission.storage.status;
      if (!permStatus.isGranted) {
        print("take grant");
        await Permission.storage.request();
      } else {
        print("is granted");
      }

      ScreenshotController screenshotController = ScreenshotController();
      screenshotController.captureFromWidget(
          QrImage(
            backgroundColor: Colors.white,
            size: 500,
            data: textToGenerate!,
            version: QrVersions.auto,
            gapless: false,
          ),
      ).then((capturedImage) async {
        if (capturedImage != null) {
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = await File('${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png').create();
          await imagePath.writeAsBytes(capturedImage);

          await ImageGallerySaver.saveFile(imagePath.path);
        }
        pngBytes = capturedImage;

      });
    } catch (e) {
      print("EXCEPTION!!!");
      print(e);
    }
  }

  Widget _generateQRImage(String? textToGenerate) {
    if (textToGenerate != "") {
      return PrettyQr(
        image: const AssetImage('assets/images/my_embedded_image.png'),
        size: 200,
        data: textToGenerate!,
        errorCorrectLevel: QrErrorCorrectLevel.M,
        roundEdges: true,
      );
    }
    return const Text("");
  }
}
