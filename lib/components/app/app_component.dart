import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../../config/routes/application.dart';
import '../../config/routes/routes.dart';
import '../../libraries/global_colors.dart' as global_color;

class AppComponent extends StatefulWidget {
  const AppComponent({Key? key}) : super(key: key);

  @override
  State createState() {
    return AppComponentState();
  }
}

class AppComponentState extends State<AppComponent> {
  AppComponentState() {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'QR Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: global_color.primarySwatch,
      ),
      onGenerateRoute: Application.router.generator,
    );
    return app;
  }
}