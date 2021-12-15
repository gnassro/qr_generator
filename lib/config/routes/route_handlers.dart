
import '../../components/pages/home_component.dart';
import '../../components/pages/download_component.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';


var notFound = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return ;
    });

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const HomeComponent();
    });

var downloadHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String? inputTextToGenerate = params["inputTextToGenerate"]?.first;
      int? qrColor = int.parse(params["qrColorToDownload"]!.first);
      int? backgroundQrColor = int.parse(params["backgroundQrColor"]!.first);
      bool? qrGap = (params["gapState"]!.first.toLowerCase() == "true");
      return DownloadComponent(
        inputTextToGenerate: inputTextToGenerate!,
        qrColor: Color(qrColor),
        backgroundQrColor: Color(backgroundQrColor),
        qrGap: qrGap,
      );
    });