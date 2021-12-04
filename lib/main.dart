import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrgenerator/pages/home.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Admob
  MobileAds.instance.initialize();
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Generator',
        home: KeyboardDismissOnTap(
          child: QrGenerateApp(),
        ));
  }
}
