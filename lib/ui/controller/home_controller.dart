import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/ui/models/dual_wallpaper_data.dart';
import 'package:wallpapers/ui/models/image_data.dart';
import 'package:wallpapers/ui/models/user_data.dart';

import '../constant/api_constants.dart';
import '../models/avail_data.dart';

class HomeController extends GetxController {
  var isDataLoading = false.obs;
  var isLoggedIn = false.obs;
  late User? _user; // Firebase user
  final userData = Rxn<UserData?>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFirestore db = FirebaseFirestore.instance;
  var goToLogin = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _user = _auth.currentUser;
    isLoggedIn(_user != null);
    if (isLoggedIn()) {
      checkUserOnServer();
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  logOutUser() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _user = null;
    isLoggedIn(false);
    print("User Sign Out");
  }

  Future<User?> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication!.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential authResult = await _auth.signInWithCredential(credential);

    _user = authResult.user!;

    assert(!_user!.isAnonymous);

    assert(await _user!.getIdToken() != null);

    User? currentUser = await _auth.currentUser;

    assert(_user!.uid == currentUser?.uid);

    await checkUserOnServer();
    isLoggedIn(true);

    print("User Name: ${_user!.displayName}");
    print("User Email ${_user!.email}");
    print("Phone number ${_user!.phoneNumber}");

    return _user;
  }

  checkUserOnServer() async {
    // final docRef = db.collection("users").doc(_user!.uid);
    // docRef.get().then(
    //   (DocumentSnapshot doc) {
    //     if (doc.data() != null) {
    //       final data = doc.data() as Map<String, dynamic>;
    //       userData(UserData.fromJson(data));
    //       print(data);
    //     } else {
    //       createUserOnFireStore();
    //     }
    //   },
    //   onError: (e) {
    //     createUserOnFireStore();
    //     print("Error getting document: $e");
    //   },
    // );
    try {
      var url = Uri.https(ApiConstant.baseUrl,
          ApiConstant.getUserById.replaceAll(":id", _user!.uid));
      var response = await http.get(url);
      print('Request url: ${response.request?.url}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        userData(UserData.fromJson(jsonDecode(response.body)));
      } else {
        createUserOnServer();
      }
    } catch (ex) {
      createUserOnServer();
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }

  createUserOnServer() async {
    // var user = UserData(
    //     id: _user!.uid,
    //     displayName: _user!.displayName,
    //     email: _user!.email,
    //     streaksPoint: 20);
    // db.collection("users").doc(_user!.uid).set(user.toJson());
    // userData(UserData.fromJson(user));

    try {
      var url = Uri.https(ApiConstant.baseUrl, ApiConstant.userSignUp);
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      var response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "displayName": _user!.displayName,
            "email": _user!.email,
            "googleId": _user!.uid,
            "_id": _user!.uid
          }));
      print('Request url: ${response.request?.url}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        userData(UserData.fromJson(jsonDecode(response.body)));
      }
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }

  updateStreaks(int earnStreaks) async {
    // final docRef = db.collection("users").doc(_user!.uid);
    // var userFinalStreak = userData.value!.streakPoint! + earnStreaks;
    //
    // docRef.update({"streaksPoint": userFinalStreak}).then(
    //     (value) => checkUserOnServer());

    try {
      var url = Uri.https(ApiConstant.baseUrl,
          ApiConstant.updateUserById.replaceAll(":id", _user!.uid));
      var userFinalStreak = userData.value!.streakPoint! + earnStreaks;
      var response = await http
          .put(url, body: {"streakPoint": userFinalStreak.toString()});
      print('Request url: ${response.request?.url}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        checkUserOnServer();
      }
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }

  availImage(ImageData imageData) async {
    try {
      final queryParameters = {
        'userId': _user!.uid,
        'imageId': imageData.id,
      };
      var url = Uri.https(
          ApiConstant.baseUrl, ApiConstant.availImage, queryParameters);
      var response = await http.post(url);
      print('Request url: ${response.request?.url}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        return true;
      }
      return false;
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      return false;
    }
  }

  checkAvailImage(ImageData imageData) async {
    try {
      final queryParameters = {
        'userId': _user!.uid,
        'imageId': imageData.id,
      };
      var url = Uri.https(
          ApiConstant.baseUrl, ApiConstant.checkAvailImage, queryParameters);
      var response = await http.get(url);
      print('Request url: ${response.request?.url}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        AvailData availData = AvailData.fromJson(jsonDecode(response.body));
        return availData.isAlreadyBought;
      }
      return false;
    } catch (ex) {
      return false;
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }

  availDualWallpaper(DualWallpaperData dualWallpaperData) async {
    try {
      final queryParameters = {
        'userId': _user!.uid,
        'dualWallpaperId': dualWallpaperData.id,
      };
      var url = Uri.https(
          ApiConstant.baseUrl, ApiConstant.availDualWallpaper, queryParameters);
      var response = await http.post(url);
      print('Request url: ${response.request?.url}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        return true;
      }
      return false;
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      return false;
    }
  }

  checkAvailDualWallpaper(DualWallpaperData dualWallpaperData) async {
    try {
      final queryParameters = {
        'userId': _user!.uid,
        'dualWallpaperId': dualWallpaperData.id,
      };
      var url = Uri.https(ApiConstant.baseUrl,
          ApiConstant.checkAvailDualWallpaper, queryParameters);
      var response = await http.get(url);
      print('Request url: ${response.request?.url}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        AvailData availData = AvailData.fromJson(jsonDecode(response.body));
        return availData.isAlreadyBought;
      }
      return false;
    } catch (ex) {
      return false;
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }
}
