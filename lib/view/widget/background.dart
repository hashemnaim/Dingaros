import 'package:dinengros/Controller/getxController/getx.dart';
import 'package:dinengros/Controller/helper/sp_helper.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/view/screen/main_screen/widget/floating_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_image.dart';
import 'custom_text.dart';

class Background extends StatefulWidget {
  final Widget contant;
  final bool logo, back, notfi, user;

  Background({
    Key key,
    this.contant,
    this.logo = false,
    this.back = false,
    this.notfi = false,
    this.user = false,
  }) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  AppGet appGet = Get.find();
  List listUser;
  @override
  void initState() {
    listUser = appGet.listUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(appGet.stop.value);
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: CustomPngImage(
              imageName: "bg",
              fit: BoxFit.fill,
              height: Get.height,
              width: Get.width,
            ),
          ),

          widget.logo == false
              ? Container()
              : Positioned(
                  // left: 0,
                  right: 10.w,
                  bottom: 4.h,
                  child: Column(
                    children: [
                      CustomText(
                        "Powered by",
                        fontSize: 12.sp,
                      ),
                      SizedBox(height: 4.h),
                      CustomSvgImage(
                        imageName: "logo",
                        fit: BoxFit.contain,
                        height: 20.h,
                        width: 50.w,
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
          widget.notfi == false
              ? Container()
              : Obx(() {
                  print(appGet.stop.value);
                  return Positioned(
                    right: 10.w,
                    top: 45.h,
                    child: GestureDetector(
                      onTap: () {
                        // appGet.stop.value = !appGet.stop.value;

                        appGet.stopAlert();
                        // setState(() {});
                      },
                      child: CustomSvgImage(
                        imageName:
                            appGet.stop.value == false ? "notfi" : "notfi1",
                        fit: BoxFit.contain,
                        width: 30.w,
                        height: 30.h,
                      ),
                    ),
                  );
                }),

          // ),
          widget.back == false
              ? Container()
              : Positioned(
                  left: 10.w,
                  top: 45.h,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: CustomSvgImage(
                      imageName: "back",
                      fit: BoxFit.contain,
                      width: 30.w,
                      height: 30.h,
                    ),
                  ),
                ),
          Positioned(
            left: 0,
            right: 0,
            child: CustomSvgImage(
              imageName: "header",
              fit: BoxFit.fill,
              height: 45.h,
              width: Get.width,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 16.h,
            child: CustomPngImage(
              imageName: "mini_logo",
              fit: BoxFit.contain,
              width: 40.w,
              height: 30.h,
            ),
          ),
          widget.notfi == false
              ? Container()
              : Positioned(
                  left: 108.w,
                  top: 40.h,
                  child: CustomText(
                    SPHelper.spHelper.getText("name"),
                    color: AppColors.primary2,
                    fontSize: 22,
                  ),
                ),

          widget.user == false
              ? Container()
              : Positioned(
                  left: 0,
                  right: 0,
                  top: 80.h,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: TypeAheadField(
                          suggestionsBoxVerticalOffset: 2,
                          direction: AxisDirection.down,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: appGet.userController.value,
                            autofocus: false,
                            focusNode: appGet.userOrderFocus,
                            decoration: InputDecoration(
                              hintText: "Brukere",
                              fillColor: Colors.white,
                              filled: true,
                              focusColor: AppColors.primary,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                icon: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 8.r,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    )),
                                onPressed: () {
                                  appGet.userController.value.text = "";
                                  appGet.idUserController.value.text = "";
                                  // appGet.barCodeFocus.unfocus();
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                              ),
                            ),
                          ),
                          suggestionsCallback: (input) {
                            print(input);
                            // appGet.userController.value.text = input;

                            return listUser
                                .where((e) => e['name']
                                    .toString()
                                    .toLowerCase()
                                    .contains(input.toLowerCase()))
                                .toList();
                          },
                          itemBuilder: (_, suggestion) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 2.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    suggestion["name"],
                                    fontSize: 12.sp,
                                  ),
                                  Divider()
                                ],
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            appGet.userController.value.text =
                                suggestion['name'];
                            appGet.idUserController.value.text =
                                suggestion['id'].toString();
                            print(appGet.idUserController.value.text);

                            // setState(() {});
                          })),
                ),

          Positioned(
              left: 0,
              right: 0,
              top: widget.user == false ? 65.h : 124.h,
              child: widget.contant),

          widget.logo != false
              ? Container()
              : Positioned(right: 0, bottom: 10.h, child: FloatingCustom()),
        ],
      );
    });
  }
}
