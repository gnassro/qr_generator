import 'package:fluro/fluro.dart';
//import 'package:flutter/material.dart';
import 'route_handlers.dart';

class Routes {
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = notFound;

    router.define("/", handler: rootHandler);
    router.define("/download", handler: downloadHandler);
  }
}