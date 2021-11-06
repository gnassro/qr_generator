import 'package:flutter/material.dart';
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
              child: const Text("Generate")
          ),
          _generateQRImage(inputTextToGenerate),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  QrPainter(
                      data: inputTextToGenerate!,
                      version: QrVersions.auto
                  );
                });
              },
              child: const Text("Download")
          ),
        ],
      ),
    );
  }
}


Widget _generateQRImage (String? textToGenerate) {
  if (textToGenerate != "") {
    return QrImage(
      data: textToGenerate!,
      version: QrVersions.auto,
      semanticsLabel: "Qr",
      gapless: false,
      embeddedImage: const AssetImage('assets/images/my_embedded_image.png'),
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: const Size(40, 40),
      ),
    );
  }
  return const Text ("");
}