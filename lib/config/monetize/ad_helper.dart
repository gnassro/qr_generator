import 'dart:io';
import 'package:flutter_config/flutter_config.dart';

class AdHelper {
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return FlutterConfig.get('ANDROID_INTERSTITIAL_AD_UNIT_ID'); // you must define .dev file
      //return "ca-app-pub-3940256099942544/5224354917"; // use this for the test
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}