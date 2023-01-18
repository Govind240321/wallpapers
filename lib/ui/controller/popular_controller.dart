import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/ui/models/images_data_api.dart';
import 'package:wallpapers/ui/models/photos_data.dart';

class PopularController extends GetxController {
  var isDataLoading = false.obs;
  RxList<PhotosData> imagesList = (List<PhotosData>.of([])).obs;
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
            event.docs.map((doc) => PhotosData.fromJson(doc.data())).toList());
        imagesList.shuffle();
      });
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    } finally {
      isDataLoading(false);
    }
  }

  fetchImages() async {
    try {
      http.Response response = await http.get(
          Uri.tryParse(
              'https://api.pexels.com/v1/curated?page=$mPage&per_page=30&orientation=portrait')!,
          headers: {
            'Authorization':
                '563492ad6f9170000100000161570a288a2d4602a2167ce1b055fd4a'
          });
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        imagesList.addAll(ImagesDataApi.fromJson(result)
            .photos!
            .take(ImagesDataApi.fromJson(result).photos!.length)
            .map((e) => PhotosData(
                id: "${e.id}",
                imageUrl: e.src?.portrait,
                premium: false,
                points: 0,
                userId: "")));
        if (mPage == 1) {
          imagesList.shuffle();
        }
      } else {
        ///error
        print('Error while getting data is =============>>>>>>>>>');
      }
    } catch (e) {
      log('Error while getting data is $e');
      print('Error while getting data is $e');
    } finally {
      isDataLoading(false);
    }
  }
}
