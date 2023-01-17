import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallpapers/ui/models/photos_data.dart';

class ProfileController extends GetxController {
  var isDataLoading = false.obs;
  late User? user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  RxList<PhotosData> myImagesList = (List<PhotosData>.of([])).obs;
  var uploading = false.obs;

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
      final docRef = db.collection("users").doc(user?.uid).collection("images");
      docRef.get().then((event) {
        myImagesList(
            event.docs.map((doc) => PhotosData.fromJson(doc.data())).toList());
        isDataLoading(false);
      });
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }

  makeMultipleRequests(List<XFile> xFiles) async {
    uploading(true);
    await Future.forEach(xFiles, (file) async {
      await sendFiles(file);
    });
    uploading(false);
  }

  sendFiles(XFile xFile) async {
    try {
      var uri =
          Uri.parse('https://api.cloudinary.com/v1_1/drl3zlwrd/image/upload');
      http.MultipartRequest request = http.MultipartRequest('POST', uri);
      // Fields
      request.fields['upload_preset'] = "wx7q260n";
      request.fields['api_key'] = "485395134754944";
      request.files.add(await http.MultipartFile.fromPath('file', xFile.path,
          contentType: MediaType("image", getFileExtension(xFile.name))));
      http.StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        var jsonData = jsonDecode(value);
        addToFirebase(PhotosData(
            id: jsonData["asset_id"],
            imageUrl: jsonData["secure_url"],
            premium: false));
        print('===============$value==================');
      });
    } catch (err) {
      print(err);
    }
  }

  addToFirebase(PhotosData imageObject) {
    db
        .collection("users")
        .doc(user!.uid)
        .collection("images")
        .doc(imageObject.id)
        .set(imageObject.toJson())
        .then(
      (doc) {
        print("Document added");
        getUserImages();
      },
      onError: (e) => print("Error updating document $e"),
    );
  }

  String getFileExtension(String fileName) {
    return ".${fileName.split('.').last}";
  }
}
