import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/ui/models/videos_data.dart';

import '../constant/api_constants.dart';

class VideosController extends GetxController {
  var isDataLoading = true.obs;
  RxList<VideoData> videosList = (List<VideoData>.of([])).obs;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var mStart = 0;
  var paginationEnded = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    getVideos();
  }

  @override
  void onClose() {}

  getVideos() async {
    try {
      if (mStart == 0) {
        isDataLoading(true);
      }
      final queryParameters = {
        'start': mStart.toString(),
        'limit': ApiConstant.limit.toString(),
      };
      var url = Uri.http(
          ApiConstant.baseUrl, ApiConstant.getAllVideos, queryParameters);
      var response = await http.get(url);
      print('Request url: ${response.request?.url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        List<dynamic> result = jsonDecode(response.body);
        paginationEnded = result.isEmpty;
        var list = result.map((e) => VideoData.fromJson(e)).toList();
        list.shuffle();
        for (var i = 1; i < list.length - 1; i++) {
          if (i % 3 == 0) {
            list.insert(i, VideoData(type: "ad"));
          }
        }
        if (mStart == 0) {
          videosList(list);
        } else {
          videosList.addAll(list);
        }
      }
      isDataLoading(false);
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      isDataLoading(false);
    }
  }
}
