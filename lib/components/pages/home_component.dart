import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import '../../libraries/global_colors.dart' as global_colors;
import 'package:fluro/fluro.dart';

import '../../config/routes/application.dart';
import '../widgets/body_components.dart';

class HomeComponent extends StatefulWidget {
  const HomeComponent({Key? key}) : super(key: key);

  @override
  _QrGenerateAppState createState() => _QrGenerateAppState();
}

class _QrGenerateAppState extends State<HomeComponent> {
  String? inputTextToGenerate;
  Uint8List? pngBytes;

  bool? gapState;
  BodyCompo qrBody = BodyCompo();
  double? imageSIze;
  Color? qrColor = global_colors.blackColor;
  Color? backgroundQrColor = global_colors.whiteColor;
  Color? qrColorToDownload = global_colors.blackColor;
  Color? backgroundQrColorToDownload = global_colors.whiteColor;


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

    return Scaffold(
      backgroundColor: global_colors.appBackgroundColor,
      body: Center(
        child: ListView(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            qrBody.inputBuilder(
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
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 20.0
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0)),
        ),
        child: const Text("Download"),
        onPressed: () {
          Application.router.navigateTo(
            context,
            "download?inputTextToGenerate=" + inputTextToGenerate! +
                "&qrColorToDownload=" + qrColorToDownload!.value.toString() +
                "&backgroundQrColor=" + backgroundQrColorToDownload!.value.toString() +
              "&gapState=" + gapState.toString(),
            transition: TransitionType.inFromBottom,
            transitionDuration: const Duration(milliseconds: 600)
          ).then((result) {
            setState(() {
              print(result);
              if (result != null) {
                inputTextToGenerate = result["inputTextToGenerate"];
                qrColorToDownload = result["qrColor"];
                backgroundQrColorToDownload = result["backgroundQrColor"];
                gapState = result["qrGap"];
              }
            });
          });
        },
      ),
    );
  }
}