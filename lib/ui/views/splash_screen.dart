import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:wallpapers/ui/constant/constants.dart';
import 'package:wallpapers/ui/controller/splash_controller.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/views/components/wallart_logo.dart';
import 'package:wallpapers/ui/views/home_screen.dart';
import 'package:wallpapers/ui/views/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;
  SplashController splashController = Get.put(SplashController());

  @override
  void initState() {
    super.initState();

    splashController.splashVideoUrl.listen((splashUrl) {
      if (splashUrl != null) {
        _controller = VideoPlayerController.network(splashUrl)
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _controller?.play();
            _controller?.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
            Timer(
                const Duration(seconds: 5),
                () => {
                      if (splashController.isFirstTime)
                        {Go.offUntil(() => OnboardingScreen())}
                      else
                        {Go.offUntil(() => HomeScreen())}
                    });
          });
      } else {
        _controller = VideoPlayerController.asset("assets/splash.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _controller?.play();
            _controller?.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
            Timer(
                const Duration(seconds: 5),
                () => {
                      if (splashController.isFirstTime)
                        {Go.offUntil(() => OnboardingScreen())}
                      else
                        {Go.offUntil(() => HomeScreen())}
                    });
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      alignment: Alignment.center,
      child: Stack(children: [
        _controller != null ? VideoPlayer(_controller!) : Container(),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.5),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  FadeAnimatedText(Constants.tagLineSplash,
                      textStyle: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                            color: Colors.white54,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      textAlign: TextAlign.end,
                      duration: const Duration(seconds: 5))
                ],
              ),
              const SizedBox(height: 10),
              WallArtLogo(),
              const SizedBox(height: 10)
            ],
          ),
        )
      ]),
    ));
  }
}
