
import 'package:flutter/material.dart';
import 'package:wallpapers/ui/views/components/fade_in_animation.dart';

extension WidgetExtension on Widget{
  Widget fadeAnimation(double delay){
    return FadeInAnimation(delay: delay, child: this);
  }
}