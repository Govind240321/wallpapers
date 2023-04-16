import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/ui/models/category_data.dart';

import '../constant/api_constants.dart';

class DiscoverController extends GetxController {
  var isTrendingDataLoading = true.obs;
  var isPopularDataLoading = true.obs;
  var isAllDataLoading = true.obs;
  RxList<CategoryData> trendingList = (List<CategoryData>.of([])).obs;
  RxList<CategoryData> popularList = (List<CategoryData>.of([])).obs;
  RxList<CategoryData> categoryList = (List<CategoryData>.of([])).obs;

  @override
  void onInit() {
    super.onInit();
    getTrending();
    getPopularCategories();
    getAllCategories();
  }

  getTrending() async {
    try {
      isTrendingDataLoading(true);
      var url =
          Uri.http(ApiConstant.baseUrl, ApiConstant.getTrendingCategories);
      var response = await http.get(url);
      print('Request url: ${response.request?.url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        List<dynamic> result = jsonDecode(response.body);
        trendingList(result.map((e) => CategoryData.fromJson(e)).toList());
      }
      isTrendingDataLoading(false);
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      isTrendingDataLoading(false);
    }
  }

  getPopularCategories() async {
    try {
      isPopularDataLoading(true);
      var url = Uri.http(ApiConstant.baseUrl, ApiConstant.getPopularCategories);
      var response = await http.get(url);
      print('Request url: ${response.request?.url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        List<dynamic> result = jsonDecode(response.body);
        popularList(result.map((e) => CategoryData.fromJson(e)).toList());
      }
      isPopularDataLoading(false);
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      isPopularDataLoading(false);
    }
  }

  getAllCategories() async {
    try {
      isAllDataLoading(true);
      var url = Uri.http(ApiConstant.baseUrl, ApiConstant.getAllCategories);
      var response = await http.get(url);
      print('Request url: ${response.request?.url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        List<dynamic> result = jsonDecode(response.body);
        categoryList(result.map((e) => CategoryData.fromJson(e)).toList());
      }
      isAllDataLoading(false);
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      isAllDataLoading(false);
    }
  }
}
