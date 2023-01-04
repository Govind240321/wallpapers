import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/models/category_data.dart';

class DiscoverController extends GetxController {
  var isDataLoading = true.obs;
  RxList<CategoryItem> categoryList = (List<CategoryItem>.of([])).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // getApi();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    getCategories();
  }

  @override
  void onClose() {}

  getCategories() async {
    try {
      isDataLoading(true);
      FirebaseFirestore.instance.collection("categories").get().then((event) {
        categoryList(event.docs.map((doc) => CategoryItem(
            doc.id, doc.data()["name"], doc.data()["thumbnailUrl"])).toList());
        isDataLoading(false);
      });
    } catch (e) {
      log('Error while getting data is $e');
      print('Error while getting data is $e');
    }
  }

// getApi() async {
//   try {
//     isDataLoading(true);
//     http.Response response = await http.get(
//         Uri.tryParse('http://dummyapi.io/data/v1/user')!,
//         headers: {'app-id': '6218809df11d1d412af5bac4'});
//     if (response.statusCode == 200) {
//       ///data successfully
//
//       var result = jsonDecode(response.body);
//
//       user_model = User_Model.fromJson(result);
//     } else {
//       ///error
//     }
//   } catch (e) {
//     log('Error while getting data is $e');
//     print('Error while getting data is $e');
//   } finally {
//     isDataLoading(false);
//   }
// }
}
