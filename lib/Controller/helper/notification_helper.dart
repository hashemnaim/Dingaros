import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/Controller/helper/sp_helper.dart';
import 'package:dinengros/view/screen/main_screen/orders_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../getxController/getx.dart';

class NotificationHelper {
  String fcmToken = '';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  Map<String, dynamic> message = {};
  AppGet appGet = Get.find();

  initialNotification() {
    getToken();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            alert: true, badge: true, provisional: true, sound: true));

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        this.message = message;

        // showNotification(
        //   message['notification']['title'],
        //   message['notification']['body'],
        // );
        appGet.playAlert();
        await ApiServer.instance.getOrders();
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        this.message = message;
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        this.message = message;

        print('messasaf');
      },
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {}
  }

  void showNotification(String title, String body) async {
    await _demoNotification(
      title,
      body,
    );
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID',
      'channel name',
      'channel description',
      importance: Importance.max,
      playSound: true,
      showProgress: true,
      priority: Priority.high,
      ticker: 'test ticker',
    );

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: '');
  }

  getToken() async {
    firebaseMessaging.subscribeToTopic('all');

    fcmToken = await firebaseMessaging.getToken();

    print("the token id : $fcmToken");

    await SPHelper.spHelper.setFcmToken(fcmToken);

    // firebaseMessaging.subscribeToTopic(token);

    return fcmToken;
  }
}
