import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wallpapers/ui/constant/get_pages_constant.dart';
import 'package:wallpapers/ui/constant/route_constant.dart';
import 'package:wallpapers/ui/views/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message ${message.data}");
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }

  void getToken() async {
    await FirebaseMessaging.instance
        .getToken()
        .then((token) => {print("Firebase token: $token")});
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User grant permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User decline permission");
    }
  }

  initInfo() {
    var androidInitialize = const AndroidInitializationSettings("ic_launcher");
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse notificationResponse) async {
      print(notificationResponse);
    }, onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      print("Foreground Notification ${notificationResponse.payload}");
    });

    FirebaseMessaging.onMessage.listen((remoteMessage) async {
      print("-----------------------onMessage-----------------------------");
      print(
          "onMessage: ${remoteMessage.notification?.title}/${remoteMessage.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          remoteMessage.notification?.body ?? "",
          htmlFormatBigText: true,
          contentTitle: remoteMessage.notification?.title.toString(),
          htmlFormatContentTitle: true);

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails("wallpaper", "wallpaper",
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              icon: "@mipmap/ic_launcher",
              priority: Priority.high);
      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
          0,
          remoteMessage.notification?.title,
          remoteMessage.notification?.body,
          notificationDetails,
          payload: remoteMessage.data['body']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: getPages,
      initialRoute: RouteConstant.splashScreen,
      home: SplashScreen(),
    );
  }
}
