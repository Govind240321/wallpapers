import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallpapers/ui/models/user_data.dart';

class HomeController extends GetxController {
  var isDataLoading = false.obs;
  var isLoggedIn = false.obs;
  late User? _user; // Firebase user
  final userData = Rxn<UserData?>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    // getApi();
    _user = _auth.currentUser;
    isLoggedIn(_user != null);
    if (isLoggedIn()) {
      checkUserOnFirebase();
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

    await checkUserOnFirebase();
    isLoggedIn(true);

    print("User Name: ${_user!.displayName}");
    print("User Email ${_user!.email}");

    return _user;
  }

  checkUserOnFirebase() async {
    final docRef = db.collection("users").doc(_user!.uid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        // final data = doc.data() as Map<String, dynamic>;
        // print(data);
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          userData.value = UserData.fromJson(data);
          print(data);
        } else {
          createUserOnFireStore();
        }
      },
      onError: (e) {
        createUserOnFireStore();
        print("Error getting document: $e");
      },
    );
  }

  createUserOnFireStore() {
    var user = UserData(
        id: _user!.uid,
        displayName: _user!.displayName,
        email: _user!.email,
        streaksPoint: 20);
    db.collection("users").doc(_user!.uid).set(user.toJson());
    userData.value = UserData.fromJson(user);
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
