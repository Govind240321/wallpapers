import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
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
