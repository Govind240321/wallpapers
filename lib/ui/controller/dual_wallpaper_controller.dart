import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/models/dual_wallpaper_data.dart';

class DualWallpaperController extends GetxController {
  var isDataLoading = true.obs;
  RxList<DualWallpaperData> dualWallpaperList =
      (List<DualWallpaperData>.of([])).obs;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    getAllDualWallpaper();
  }

  getAllDualWallpaper() async {
    try {
      isDataLoading(true);
      final docRef = db.collection("dual_wallpaper");
      docRef.get().then((event) {
        dualWallpaperList(event.docs
            .map((doc) => DualWallpaperData.fromJson(doc.data()))
            .toList());
        dualWallpaperList.shuffle();
        isDataLoading(false);
      });
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      isDataLoading(false);
    }
  }
}
