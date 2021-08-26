import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/Controller/getxController/getx.dart';
import 'package:dinengros/Controller/helper/sp_helper.dart';
import 'package:dinengros/value/animate_do.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'auth_screen/sign_in_screen.dart';
import 'main_screen/home_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AppGet appGet = Get.find();

  @override
  void initState() {
    var delay = Duration(seconds: 2);
    String token = SPHelper.spHelper.getToken();
    print(token);
    appGet.token.value = token;

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
    super.initState();
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
