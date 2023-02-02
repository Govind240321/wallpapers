import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/category_data.dart';
import '../models/image_data.dart';

class ImagesController extends GetxController {
  var isDataLoading = true.obs;
  RxList<ImageData> imagesList = (List<ImageData>.of([])).obs;
  FirebaseFirestore db = FirebaseFirestore.instance;
  CategoryItem? categoryItem;

  @override
  void onInit() {
    super.onInit();
    categoryItem = Get.arguments['categoryItem'];
    getAllImagesByCategoryId(categoryItem?.id ?? "");
  }

  getAllImagesByCategoryId(String categoryId) async {
    try {
      isDataLoading(true);
      final docRef = db
          .collection("users_images")
          .where("categoryId", isEqualTo: categoryId);
      docRef.get().then((event) {
        imagesList(
            event.docs.map((doc) => ImageData.fromJson(doc.data())).toList());
        imagesList.shuffle();
        isDataLoading(false);
      });
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      isDataLoading(false);
    }
  }
}
