import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:front_app/pages/SettingPage.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:front_app/scope_models/AppModel.dart';
import 'package:front_app/pages/RegisterPage.dart';
import 'package:front_app/pages/AuthPage.dart';
import 'package:front_app/pages/Dashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  AppModel model = new AppModel();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _fLocalNoty = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      sound: true
    );

    var android = new AndroidInitializationSettings("mipmap/ic_launcher");
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios);
    _fLocalNoty.initialize(platform);

    FirebaseMessaging.onMessage.listen((event) {
      (Map<String, dynamic> msg) async {
        print("onMessage Called $msg");
        showNotification(msg);
      };
    });
    model.getToken().then((value){});
    _messaging.getToken().then((token) {
      print('Token: $token');
      model.sendFCMTokenToServer(token!).then((res) {
        print('Result: ' + res.toString());
      });
    });
  }

  void showNotification(Map<String, dynamic> msg) async {
    var android = const AndroidNotificationDetails(
      'channel_id',
      'channel_name'
    );
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: ios);
    Map<dynamic, dynamic> notification = msg["notification"];
    String title = notification['title'];
    String body = notification['body'];

    await _fLocalNoty.show(0, title, body, platform);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.greenAccent,
          accentColor: Colors.green
        ),
        routes: {
          '/' : (context) {
            return AuthPage();
          },
          '/register' : (context) {
            return RegisterPage();
          },
          '/dashboard': (context) {
            return Dashboard();
          },
          '/setting' : (context) {
            return SettingPage();
          }
        },
      ),
    );
  }
}
