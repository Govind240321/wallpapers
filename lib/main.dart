import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/constant/get_pages_constant.dart';
import 'package:wallpapers/ui/constant/route_constant.dart';
import 'package:wallpapers/ui/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: getPages,
      title: 'Rest API Using GetX Demo',
      initialRoute: RouteConstant.splashScreen,
      home: SplashScreen(),
    );
  }
}
