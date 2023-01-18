import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_frame/device_frame.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpapers/ui/controller/home_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> listSlider = ["assets/1.webp", "assets/2.webp", "assets/3.webp"];
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 380,
            width: 200,
            child: DeviceFrame(
              device: Platform.isAndroid
                  ? Devices.android.onePlus8Pro
                  : Devices.ios.iPhone13,
              isFrameVisible: true,
              orientation: Orientation.portrait,
              screen: Container(
                color: Colors.white,
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.7,
                    aspectRatio: 0.8,
                    initialPage: 0,
                  ),
                  items: listSlider.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: deviceWidth,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              child: Image.asset(
                                item,
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                              ),
                            ));
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Personalize your phone \nWith our Wide \nSelection of wallpapers",
            textAlign: TextAlign.center,
            style: GoogleFonts.anton(
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: () {
              _doLogin();
            },
            child: Container(
              width: deviceWidth * 0.5,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/google.webp", height: 24, width: 24),
                    const SizedBox(width: 10),
                    Text(
                      "Login with Google",
                      style: GoogleFonts.anton(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1,
                              fontSize: 12)),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ).fadeAnimation(0.5),
    );
  }

  _doLogin() {
    homeController.signInWithGoogle().then((User? user) {
      print(user);
    }).catchError((e) => print(e));
  }
}
