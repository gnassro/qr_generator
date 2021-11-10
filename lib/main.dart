import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
        title: const Text('QR Generate',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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

  Widget _generateQRImage(String? textToGenerate) {
    if (textToGenerate != "") {
      return QrImage(
        constrainErrorBounds: false,
        backgroundColor: Colors.white,
        size: 500,
        data: textToGenerate!,
        version: QrVersions.auto,
        gapless: false,
      );
    }
    return const Text("");
  }
}