
import '../../components/pages/home_component.dart';
import '../../components/pages/download_component.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt_key;



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
      final key = encrypt_key.Key.fromUtf8('my 32 length key................');
      final iv = encrypt_key.IV.fromLength(16);
      final encrypter = encrypt_key.Encrypter(encrypt_key.AES(key));

      String? inputTextToGenerate = encrypter.decrypt64(params["inputTextToGenerate"]!.first, iv: iv);

      int? qrColor = int.parse(params["qrColorToDownload"]!.first);
      int? backgroundQrColor = int.parse(params["backgroundQrColor"]!.first);
      bool? qrGap = (params["gapState"]!.first.toLowerCase() == "true");
      return DownloadComponent(
        inputTextToGenerate: inputTextToGenerate,
        qrColor: Color(qrColor),
        backgroundQrColor: Color(backgroundQrColor),
        qrGap: qrGap,
      );
    });