
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WallArtLogo extends StatelessWidget {
  var colorizeColors = [
    Colors.white54,
    Colors.yellow.withOpacity(0.54),
    Colors.red.withOpacity(0.54),
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 32.0,
    fontFamily: 'Rubik Storm',
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedTextKit(
            isRepeatingAnimation: true,
            animatedTexts: [
          ColorizeAnimatedText(
            'WallArt',
            speed: const Duration(seconds: 2),
            textStyle: GoogleFonts.sancreek(textStyle: const TextStyle(fontSize: 52)), colors: colorizeColors
          )
        ]
        )
      ],
    );
  }

}