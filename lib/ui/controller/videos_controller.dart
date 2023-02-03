import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/models/videos_data.dart';

class VideosController extends GetxController {
  var isDataLoading = true.obs;
  RxList<VideoData> videosList = (List<VideoData>.of([])).obs;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    getVideos();
  }

  @override
  void onClose() {}

  getVideos() async {
    try {
      isDataLoading(true);
      final docRef = db.collection("videos");
      docRef.get().then((event) {
        videosList(
            event.docs.map((doc) => VideoData.fromJson(doc.data())).toList());
        videosList.shuffle();
        isDataLoading(false);
      });
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }
}
