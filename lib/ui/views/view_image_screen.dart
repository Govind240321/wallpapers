import 'dart:async';
import 'dart:io';

import 'package:device_frame/device_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpapers/ui/controller/view_image_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';

import '../constant/constants.dart';

class ViewImageScreen extends StatefulWidget {
  const ViewImageScreen({Key? key}) : super(key: key);

  @override
  State<ViewImageScreen> createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  ViewImageController viewImageController = Get.put(ViewImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      color: Colors.black,
                    ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 6,
                      blurRadius: 7,
                      offset:
                          const Offset(10, -5), // changes position of shadow
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 6,
                          blurRadius: 7,
                          offset:
                              const Offset(5, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: DeviceFrame(
                      device: Platform.isAndroid
                          ? Devices.android.onePlus8Pro
                          : Devices.ios.iPhone13,
                      isFrameVisible: true,
                      orientation: Orientation.portrait,
                      screen: Hero(
                        tag: viewImageController.imageObject!.heroId,
                        child: Stack(
                          children: [
                            Image.network(
                              viewImageController.imageObject!.imageUrl,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                            ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            _lockScreenTimeWidget(context).fadeAnimation(0.5)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _lockScreenTimeWidget(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: (MediaQuery.of(context).size.height * 0.12)),
          Text("Newport Beach, USA | PST",
              style: Theme.of(context).textTheme.bodyText1),
          const TimeInHourAndMinute()
        ],
      ),
    );
  }
}

class TimeInHourAndMinute extends StatefulWidget {
  const TimeInHourAndMinute({Key? key}) : super(key: key);

  @override
  State<TimeInHourAndMinute> createState() => _TimeInHourAndMinuteState();
}

class _TimeInHourAndMinuteState extends State<TimeInHourAndMinute> {
  TimeOfDay _timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeOfDay.minute != TimeOfDay.now().minute) {
        setState(() {
          _timeOfDay = TimeOfDay.now();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String period = _timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${_retrieveHour()}:${_retrieveMinutes()}",
            style: Theme.of(context).textTheme.headline2),
        const SizedBox(width: 5),
        RotatedBox(
            quarterTurns: 3,
            child: Opacity(
              opacity: 0.7,
              child: Text(
                period,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ))
      ],
    );
  }

  String _retrieveMinutes() {
    var minutes = "${_timeOfDay.minute}";
    if (_timeOfDay.minute < 10) {
      minutes = "0$minutes";
    }
    return minutes;
  }

  String _retrieveHour() {
    var hour = "${_timeOfDay.hourOfPeriod}";
    if (_timeOfDay.hourOfPeriod < 10) {
      hour = "0$hour";
    }
    return hour;
  }
}
