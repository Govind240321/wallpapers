import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wallpapers/ui/constant/get_pages_constant.dart';
import 'package:wallpapers/ui/constant/route_constant.dart';
import 'package:wallpapers/ui/views/splash_screen.dart';

Future<void> main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
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
