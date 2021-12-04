import 'dart:io';
//import 'package:flutter_config/flutter_config.dart';

class AdHelper {
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      // FlutterConfig.get('FABRIC_ID')
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}