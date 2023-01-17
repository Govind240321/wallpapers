import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/models/photos_data.dart';

class ProfileController extends GetxController {
  var isDataLoading = false.obs;
  late User? user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  RxList<PhotosData> myImagesList = (List<PhotosData>.of([])).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    user = _auth.currentUser;
    getUserImages();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  getUserImages() async {
    try {
      isDataLoading(true);
      final docRef =
      db.collection("users").doc(user?.uid).collection("images");
      docRef.get().then((event) {
        myImagesList(event.docs.map((doc) => PhotosData.fromJson(doc.data())).toList());
        isDataLoading(false);
      });
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }
}
