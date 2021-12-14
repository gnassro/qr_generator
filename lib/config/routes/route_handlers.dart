
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
      return const DownloadComponent(
        inputTextToGenerate: "text to generate",
        qrColor: Color(0xff05668D),
        backgroundQrColor: Color(0xffac2d7a),
        qrGap: true,
      );
    });