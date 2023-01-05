import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/models/category_data.dart';
import 'package:wallpapers/ui/models/images_data_api.dart';
import 'package:wallpapers/ui/models/photos_data.dart';
import 'package:wallpapers/ui/models/user_data.dart';

class FavoriteController extends GetxController {
  var isDataLoading = true.obs;
  RxList<PhotosData> favList = (List<PhotosData>.of([])).obs;
  late User? _user; // Firebase user
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    // getApi();
    _user = _auth.currentUser;
    getFavorites();
  }

  @override
  void onClose() {}

  // getCategories() async {
  //   try {
  //     isDataLoading(true);
  //     FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(_user?.uid)
  //         .collection("favorites")
  //         .get()
  //         .then((event) {
  //       // categoryList(event.docs.map((doc) => CategoryItem(
  //       //     doc.id, doc.data()["name"], doc.data()["thumbnailUrl"])).toList());
  //       isDataLoading(false);
  //     });
  //   } catch (e) {
  //     log('Error while getting data is $e');
  //     print('Error while getting data is $e');
  //   }
  // }

  getFavorites() async {
    try {
      isDataLoading(true);
      final docRef =
          db.collection("users").doc(_user?.uid).collection("favorites");
      docRef.get().then((event) {
        favList(
            event.docs.map((doc) => PhotosData.fromJson(doc.data())).toList());
        isDataLoading(false);
      });
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }
}
