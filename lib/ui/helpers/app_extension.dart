import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/views/components/fade_in_animation.dart';

extension WidgetExtension on Widget {
  Widget fadeAnimation(double delay) {
    return FadeInAnimation(delay: delay, child: this);
  }
}

extension ScrollControllerUtil on ScrollController {
  bool get isLoadMore {
    double maxScroll = position.maxScrollExtent;
    double currentScroll = position.pixels;
    double delta = Get.size.width * 0.20;
    return maxScroll - currentScroll <= delta;
  }
}

extension RandomInt on int {
  static int generate({int min = 3, required int max}) {
    final _random = Random();
    return min + _random.nextInt(max - min);
  }
}
