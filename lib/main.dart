import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'capture_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.pinkAccent,
      ),
      home: ExampleScreen(),
    ),
  );
}

class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => new _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final _captureKey = GlobalKey<CaptureWidgetState>();
  Future<CaptureResult>? _image;

  void _onCapturePressed() {
    setState(() {
      _image = _captureKey.currentState!.captureImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CaptureWidget(
      key: _captureKey,
      capture: QrImage(
          constrainErrorBounds: false,
          backgroundColor: Colors.white,
          size: 500,
          data: "hjus",
          version: QrVersions.auto,
          gapless: false,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Widget To Image Demo'),
        ),
        body: FutureBuilder<CaptureResult>(
          future: _image,
          builder: (BuildContext context, AsyncSnapshot<CaptureResult> snapshot) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: RaisedButton(
                      child: Text('Capture Image'),
                      onPressed: _onCapturePressed,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

