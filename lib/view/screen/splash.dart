import 'dart:io';

import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/Controller/getxController/getx.dart';
import 'package:dinengros/Controller/helper/sp_helper.dart';
import 'package:dinengros/value/animate_do.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'auth_screen/sign_in_screen.dart';
import 'main_screen/home_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AppGet appGet = Get.find();
  launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.remak.dinengros';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchURLios() async {
    const url = " https://apps.apple.com/us/app/smile3/id1566347628";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    var delay = Duration(seconds: 2);
    String token = SPHelper.spHelper.getToken();
    print(token);
    appGet.token.value = token;

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String buildNumber = packageInfo.buildNumber;
      print(buildNumber);
      ApiServer.instance.getShowVersion().then((s) {
        print(s);
        print(s);
        print(buildNumber);
        if (s['active'] == 0) {
          if (s['version'].toString() == buildNumber) {
            if (token == null || token == '') {
              Future.delayed(delay, () async {
                Get.off(() => SignInScreen());
              });
            } else {
              Future.delayed(delay, () async {
                await ApiServer.instance.getApi();
                if (appGet.tokenBool.value == true) {
                  Get.offAll(() => HomeScreen());
                } else {
                  Get.off(() => SignInScreen());
                }
              });
            }
          } else {
            Future.delayed(Duration(milliseconds: 2500), () {
              Platform.isAndroid ? launchURL() : launchURLios();
            });
            setToast("The latest version must be updated", color: Colors.red);
            super.initState();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        logo: true,
        contant: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            child: FadeInLeftBig(
                duration: Duration(milliseconds: 500),
                animate: true,
                child: Container(
                    child: CustomLogo(
                  height: 200.h,
                  width: 200.w,
                ))),
          ),
        ),
      ),
    );
  }
}
