import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/ui/models/image_data.dart';

import '../constant/api_constants.dart';

class ProfileController extends GetxController {
  var isDataLoading = false.obs;
  late User? user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  RxList<ImageData> myImagesList = (List<ImageData>.of([])).obs;

  var mStart = 0;
  var paginationEnded = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    user = _auth.currentUser;
    getUserImages();
  }

  getUserImages() async {
    try {
      if (mStart == 0) {
        isDataLoading(true);
      }
      final queryParameters = {
        'start': mStart.toString(),
        'limit': ApiConstant.limit.toString(),
      };
      var url = Uri.http(
          ApiConstant.baseUrl,
          ApiConstant.getUserImages.replaceAll(":id", user!.uid),
          queryParameters);
      var response = await http.get(url);
      print('Request url: ${response.request?.url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        List<dynamic> result = jsonDecode(response.body);
        paginationEnded = result.isEmpty;
        if (mStart == 0) {
          myImagesList(result.map((e) => ImageData.fromJson(e)).toList());
        } else {
          myImagesList
              .addAll(result.map((e) => ImageData.fromJson(e)).toList());
        }
      }
      isDataLoading(false);
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      isDataLoading(false);
    }
  }

  String getFileExtension(String fileName) {
    return ".${fileName.split('.').last}";
  }
}
