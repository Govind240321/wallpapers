import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/image_data.dart';

class FavoriteController extends GetxController {
  var isDataLoading = true.obs;
  RxList<ImageData> favList = (List<ImageData>.of([])).obs;
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
            event.docs.map((doc) => ImageData.fromJson(doc.data())).toList());
        isDataLoading(false);
      });
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }
}
