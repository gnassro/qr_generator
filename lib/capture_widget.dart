import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CaptureWidget extends StatefulWidget {
  final Widget child;
  final Widget capture;

  const CaptureWidget({
    Key? key,
    required this.capture,
    required this.child,
  }) : super(key: key);

  @override
  CaptureWidgetState createState() => CaptureWidgetState();
}

class CaptureWidgetState extends State<CaptureWidget> {
  final _boundaryKey = GlobalKey();

  Future<CaptureResult> captureImage() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final boundary = _boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
/////

    final data2 = await QrPainter(
      data: "ffff",
      version: QrVersions.auto,
      color: Colors.indigo
    ).toImageData(2000);
    /////
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png').create();
    await imagePath.writeAsBytes(data2!.buffer.asUint8List());

    await ImageGallerySaver.saveFile(imagePath.path);

    print("width=" + image.width.toString() + " - height=" + image.height.toString() + "and pixelRatio=" + pixelRatio.toString());

    return CaptureResult(data!.buffer.asUint8List(), image.width, image.height);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final height = constraints.maxHeight * 2;
        return Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            widget.child,
            Positioned(
              left: 0.0,
              right: 0.0,
              top: height,
              height: height,
              child: Center(
                widthFactor: 4400,
                child: RepaintBoundary(
                  key: _boundaryKey,
                  child: widget.capture,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CaptureResult {
  final Uint8List data;
  final int width;
  final int height;

  const CaptureResult(this.data, this.width, this.height);
}