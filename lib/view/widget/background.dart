import 'package:dinengros/Controller/helper/sp_helper.dart';
import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/view/screen/main_screen/widget/floating_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_image.dart';
import 'custom_text.dart';

class Background extends StatefulWidget {
  final Widget contant;
  final Widget botton;
  final bool logo, back, notfi, user, bottonbool;

  Background({
    Key key,
    this.contant,
    this.botton,
    this.logo = false,
    this.back = false,
    this.notfi = false,
    this.user = false,
    this.bottonbool = false,
  }) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  AppController appGet = Get.find();
  List listUser;
  @override
  void initState() {
    listUser = appGet.listUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage(
                    "assets/images/bg.png",
                  ),
                  fit: BoxFit.fill)),
          child: Column(
            // fit: StackFit.expand,
            children: [
              CustomSvgImage(
                imageName: "header",
                fit: BoxFit.fill,
                height: 45.h,
                width: Get.width,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.back == false
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              appGet.detailFocus.requestFocus();

                              Future.delayed(Duration(milliseconds: 1)).then(
                                  (value) => SystemChannels.textInput
                                      .invokeMethod('TextInput.hide'));
                              Get.back();
                            },
                            child: CustomSvgImage(
                              imageName: "back",
                              fit: BoxFit.contain,
                              width: 25.w,
                              height: 25.h,
                            ),
                          ),
                    Column(
                      children: [
                        CustomPngImage(
                          imageName: "mini_logo",
                          fit: BoxFit.fill,
                          width: 80.w,
                          height: 30.h,
                        ),
                        CustomText(
                          SPHelper.spHelper.getText("name"),
                          color: AppColors.primary2,
                          fontSize: 18,
                        ),
                      ],
                    ),
                    widget.notfi == false
                        ? Container()
                        : Obx(() {
                            print(appGet.stop.value);
                            return GestureDetector(
                              onTap: () {
                                appGet.stopAlert();
                              },
                              child: CustomSvgImage(
                                imageName: appGet.stop.value == false
                                    ? "notfi"
                                    : "notfi1",
                                fit: BoxFit.contain,
                                width: 25.w,
                                height: 25.h,
                              ),
                            );
                          }),
                  ],
                ),
              ),
              widget.user == false
                  ? Container()
                  : Padding(
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
              Expanded(child: widget.contant),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: widget.logo == true
            ? Column(
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
              )
            : widget.bottonbool == true
                ? Container()
                : widget.botton == null
                    ? FloatingCustom()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.botton,
                          SizedBox(
                            width: Get.width / 10,
                          ),
                          FloatingCustom(),
                        ],
                      ));
  }
}
