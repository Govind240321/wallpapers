import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/models/image_data.dart';

class PopularController extends GetxController {
  var isDataLoading = false.obs;
  RxList<ImageData> imagesList = (List<ImageData>.of([])).obs;
  var mPage = 1;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUsersImages();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  fetchUsersImages() async {
    try {
      isDataLoading(true);
      final docRef = db.collection("users_images");
      docRef.get().then((event) {
        imagesList(
            event.docs.map((doc) => ImageData.fromJson(doc.data())).toList());
        imagesList.shuffle();
      });
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    } finally {
      isDataLoading(false);
    }
  }
}
