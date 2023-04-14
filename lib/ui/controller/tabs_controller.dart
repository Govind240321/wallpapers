import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'discover_controller.dart';

class MyTabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<Tab> myTabs = [];
  late TabController controller;
  DiscoverController discoverController = Get.find<DiscoverController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    myTabs = List.generate(discoverController.categoryList.length,
        (index) => Tab(text: discoverController.categoryList[index].name));
    controller = TabController(vsync: this, length: myTabs.length);
  }
}
