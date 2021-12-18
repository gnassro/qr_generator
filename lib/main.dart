import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_config/flutter_config.dart';
import 'components/app/app_component.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Admob
  if (Platform.isAndroid) {
    MobileAds.instance.initialize();
  }
  // .env load
  await FlutterConfig.loadEnvVariables();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.bottom,
      SystemUiOverlay.top
    ],
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp( const KeyboardDismissOnTap(
      child: AppComponent()
  ));
}