import 'dart:io';

import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:slider_button/slider_button.dart';
import 'package:wallpapers/ui/constant/constants.dart';
import 'package:wallpapers/ui/controller/onboarding_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/views/home_screen.dart';

import '../helpers/navigation_utils.dart';

class OnboardingScreen extends StatefulWidget {
  static const style = TextStyle(
    fontSize: 30,
    fontFamily: "Billy",
    fontWeight: FontWeight.w600,
  );

  @override
  _OnboardingScreen createState() => _OnboardingScreen();
}

class _OnboardingScreen extends State<OnboardingScreen> {
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;
  OnBoardingController onBoardingController = Get.put(OnBoardingController());

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  final pages = [
    Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: 500,
            width: 200,
            child: DeviceFrame(
              device: Platform.isAndroid
                  ? Devices.android.onePlus8Pro
                  : Devices.ios.iPhone13,
              isFrameVisible: true,
              orientation: Orientation.portrait,
              screen: Image.asset(
                "assets/1.webp",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Column(
            children: const <Widget>[
              Text(
                "Transform your",
                style: OnboardingScreen.style,
              ),
              Text(
                "device with",
                style: OnboardingScreen.style,
              ),
              Text(
                "stunning wallpapers",
                style: OnboardingScreen.style,
              ),
            ],
          ),
        ],
      ),
    ).fadeAnimation(0.5),
    Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.yellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: 500,
            width: 200,
            child: DeviceFrame(
              device: Platform.isAndroid
                  ? Devices.android.onePlus8Pro
                  : Devices.ios.iPhone13,
              isFrameVisible: true,
              orientation: Orientation.portrait,
              screen: Container(
                child: Image.asset(
                  "assets/2.webp",
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Column(
            children: const <Widget>[
              Text(
                "Discover endless",
                style: OnboardingScreen.style,
              ),
              Text(
                "inspiration for your",
                style: OnboardingScreen.style,
              ),
              Text(
                "Device's Home screen",
                style: OnboardingScreen.style,
              ),
            ],
          ),
        ],
      ),
    ).fadeAnimation(0.5),
    Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: 500,
            width: 200,
            child: DeviceFrame(
              device: Platform.isAndroid
                  ? Devices.android.onePlus8Pro
                  : Devices.ios.iPhone13,
              isFrameVisible: true,
              orientation: Orientation.portrait,
              screen: Container(
                child: Image.asset(
                  "assets/3.webp",
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          Column(
            children: const <Widget>[
              Text(
                "Find your",
                style: OnboardingScreen.style,
              ),
              Text(
                "perfect wallpaper",
                style: OnboardingScreen.style,
              ),
              Text(
                "with us!",
                style: OnboardingScreen.style,
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ],
      ),
    ).fadeAnimation(0.5)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            LiquidSwipe(
              pages: pages,
              slideIconWidget:
                  page < 2 ? const Icon(Icons.arrow_back_ios) : null,
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              enableSideReveal: true,
              liquidController: liquidController,
              enableLoop: false,
              ignoreUserGestureWhileAnimating: true,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const <Widget>[
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            if (page == 2)
              Positioned(
                bottom: 20,
                left: 50,
                right: 50,
                child: SliderButton(
                  action: () {
                    onBoardingController.markAsVisited(false);
                    Go.offUntil(() => HomeScreen());
                  },
                  label: const Text(
                    "Slide to get started",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                  icon: const Text(
                    Constants.streakIcon,
                    style: OnboardingScreen.style,
                  ),
                ),
              )
            else
              Container()
          ],
        ),
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}
