import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/Controller/getxController/getx.dart';
import 'package:dinengros/Controller/helper/sp_helper.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/view/screen/auth_screen/sign_in_screen.dart';
import 'package:dinengros/view/screen/main_screen/search_screen.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/custom_image.dart';
import 'package:dinengros/view/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'input_order_screen.dart';
import 'new_order_screen.dart';
import 'orders_screen.dart';
import 'widget/floating_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppGet appGet = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          notfi: true,
          contant: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () => Get.to(() => OrdersScreen()),
                        child: box("import", "Vare ut", true)),
                    GestureDetector(
                        onTap: () {
                          appGet.clear();
                          Get.to(() =>
                        InputOrderScreen());},
                        child: box("import-1", "Vare inn", true)),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () => Get.to(() => SearchScreen()),
                        child: box("help", "Vare Søk", true)),
                    GestureDetector(
                        onTap: () => Get.to(() => NewOrderScreen()),
                        child: box("import2", "Ny Ordre", true)),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                    onPressed: ()async {
                    await  ApiServer.instance.getLogout();
                      SPHelper.spHelper.setToken(null);
                      Get.offAll(() => SignInScreen());
                    },
                    child: Container(
                      height: 40.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary2),
                      child: Center(
                          child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    )),
              ],
            ),
          )),
      // floatingActionButton:
      //  FloatingCustom()
    );
  }

  Widget box(String svg, String name, bool hide) => Container(
        height: 97.h,
        width: 97.h,
        decoration: BoxDecoration(
            color: hide == false ? Colors.transparent : Color(0xffCCCCCC),
            border: Border.all(
                color: hide == false ? Colors.grey : AppColors.primary2),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: CustomSvgImage(
                imageName: svg,
                fit: BoxFit.contain,
                height: 49.h,
                color: AppColors.primary2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: CustomText(
                name,
                fontSize: 14.sp,
                color: hide == false ? AppColors.primary : AppColors.primary2,
              ),
            )
          ],
        ),
      );
}
