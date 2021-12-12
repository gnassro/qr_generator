import 'dart:io';
import 'package:flutter_config/flutter_config.dart';

class AdHelper {
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return FlutterConfig.get('ANDROID_INTERSTITIAL_AD_UNIT_ID');
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}