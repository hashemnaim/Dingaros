import 'dart:io';


import 'package:dinengros/view/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Controller/helper/sp_helper.dart';
import 'controller/getxController/appController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

            Get.put(AppController());

  //  await Firebase.initializeApp();
  // await NotificationHelper().initialNotification();

  await SPHelper.spHelper.initSharedPrefrences();

 

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness:
        Platform.isAndroid ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.grey,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(
    // DevicePreview(
    // enabled: true,
    // builder: (context) =>
    MyApp(),
    // ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
      designSize: Size(255, 425),
      allowFontScaling: true,
      builder: () {

        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            // builder: DevicePrevie w.appBuilder,
            // theme: ThemeData(primarySwatch: Colors.deepOrange),
            home: Splash());
      });
}
