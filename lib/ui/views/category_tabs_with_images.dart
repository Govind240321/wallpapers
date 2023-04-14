import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';

import '../constant/ads_id_constant.dart';
import '../constant/constants.dart';
import '../controller/tabs_controller.dart';
import 'images_list_screen.dart';

class CategoriesWithImagesScreen extends StatefulWidget {
  final int categoryIndex;

  const CategoriesWithImagesScreen({Key? key, required this.categoryIndex})
      : super(key: key);

  @override
  State<CategoriesWithImagesScreen> createState() =>
      _CategoriesWithImagesScreenState();
}

class _CategoriesWithImagesScreenState
    extends State<CategoriesWithImagesScreen> {
  MyTabsController tabsController = Get.put(MyTabsController());
  final getStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    tabsController.controller.animateTo(widget.categoryIndex);
    tabsController.controller.addListener(() {
      var clickCount = getStorage.read("clickCount") ?? 0;
      if (clickCount == AdsConstant.CLICK_COUNT) {
        EasyAds.instance.showAd(AdUnitType.interstitial);
        getStorage.write('clickCount', 0);
      } else {
        getStorage.write('clickCount', clickCount + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.black,
        ),
        title: Row(
          children: [
            Image.asset("assets/icon_transparent.png", height: 24, width: 24),
            const SizedBox(
              width: 8,
            ),
            Text(Constants.appName,
                textAlign: TextAlign.center,
                style: GoogleFonts.sancreek(
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.white)))
          ],
        ).fadeAnimation(0.6),
        bottom: TabBar(
            controller: tabsController.controller,
            labelStyle: GoogleFonts.anton(
                textStyle: const TextStyle(
                    fontSize: 14, letterSpacing: 1.2, color: Colors.white)),
            isScrollable: true,
            tabs: tabsController.myTabs),
      ),
      body: TabBarView(
        controller: tabsController.controller,
        children: List.generate(
            tabsController.myTabs.length,
            (index) => ImagesListScreen(
                  categoryItem:
                      tabsController.discoverController.categoryList[index],
                )),
      ),
    );
  }
}
