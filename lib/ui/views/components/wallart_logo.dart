
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpapers/ui/constant/constants.dart';

class WallArtLogo extends StatelessWidget {
  final colorizeColors = [
    Colors.white54,
    Colors.pink.withOpacity(0.54),
    Colors.pink.withOpacity(0.54),
  ];

  WallArtLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedTextKit(
            isRepeatingAnimation: true,
            animatedTexts: [
          ColorizeAnimatedText(
              Constants.appName,
              speed: const Duration(seconds: 2),
              textStyle: GoogleFonts.sancreek(
                  textStyle: const TextStyle(fontSize: 52)),
              colors: colorizeColors)
        ]
        )
      ],
    );
  }

}