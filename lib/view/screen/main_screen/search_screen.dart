import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/isload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  @override
  _DetailsOrdersListState createState() => _DetailsOrdersListState();
}

class _DetailsOrdersListState extends State<SearchScreen> {
  AppController appGet = Get.find();
  int qty;
  int index;
  int selectedProductID;
  @override
  void initState() {
    appGet.searchFocus.unfocus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        back: true,
        notfi: true,
        contant: Obx(() {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 30.h,
                    width: 300.w,
                    child: TextFormField(
                      controller: appGet.searchCodeController.value,
                      focusNode: appGet.searchFocus,
                      autofocus: kReleaseMode,
                      decoration: InputDecoration(
                        hintText: "Strekkode",
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 2,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              )),
                          onPressed: () {
                            appGet.searchCodeController.value.text = '';
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    await appGet
                        .getPostApi(appGet.searchCodeController.value.text);
                    print(appGet.content01.value);

                    await ApiServer.instance
                        .getSearchProduct(appGet.content01.value);

                    appGet.noteController.value.text =
                        appGet.searchList["note"] ?? "";
                    appGet.searchList.isEmpty ||
                            appGet.searchList['name'] == null
                        ? Container()
                        : Get.dialog(dailog());
                    appGet.searchCodeController.value.text = "";
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        height: 40,
                        width: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                        ),
                        child: IconButton(
                            icon: appGet.lodaing.value == true
                                ? IsLoad()
                                : Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                            onPressed: null)),
                  ),
                ),
                appGet.checkProducts.isEmpty
                    ? IsLoad()
                    : appGet.checkProducts["uncheckedList"].length != 0
                        ? RefreshIndicator(
                            onRefresh: () async {
                              return await ApiServer.instance
                                  .getCheckProducts();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                height: Get.height / 1.35,
                                child: ListView.builder(
                                  // itemExtent: 6,
                                  padding: EdgeInsets.zero,
                                  itemCount: appGet
                                      .checkProducts["uncheckedList"].length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: AppColors.newColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${appGet.checkProducts["uncheckedList"][index]['name']}" ??
                                              "",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF414040),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Itme Not Found",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                SizedBox(height: 4),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget dailog() => AlertDialog(
        title: Container(
          // height: 320.h,
          width: 320.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 200,
                      child: Text(
                        "${appGet.searchList['name']}" ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF414040),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: appGet.searchList['check_status'] == 2
                        ? Colors.green
                        : Colors.red,
                    child: Icon(
                      appGet.searchList['check_status'] == 2
                          ? Icons.done
                          : Icons.close,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              appGet.groupApi.value == "A"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(appGet.groupApi.value + " : ",
                              style: TextStyle(
                                color: Colors.black,
                              )),
                          SizedBox(
                            width: 4,
                          ),
                          Text(appGet.content01.value,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  : appGet.productList.isEmpty || appGet.productList.length == 0
                      ? Container()
                      : Column(
                          children: [
                            Row(
                              children: [
                                Text(appGet.product["name01"],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12)),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(appGet.product["content01"].toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Container(
                              height: 90,
                              child: ListView.builder(
                                  padding: EdgeInsets.only(bottom: 10),
                                  itemCount: appGet.productList.length - 1,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            appGet.product["name" +
                                                        appGet.productList[
                                                            index + 1]]
                                                    .toString() +
                                                " : ",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF414040),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            appGet.product["content" +
                                                    appGet
                                                        .productList[index + 1]]
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF414040),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Product Num :"
                          " ${appGet.searchList['product_num']}" ??
                      "",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF414040),
                  ),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              appGet.searchList["prices"].length == 0 ||
                      appGet.searchList["prices"] == null
                  ? Container()
                  : Container(
                      height: double.parse(
                          (20 * appGet.searchList["prices"].length).toString()),
                      width: 500,
                      // appGet.searchList["prices"].length,
                      child: ListView.builder(
                          padding: EdgeInsets.only(left: 8),
                          itemCount: appGet.searchList["prices"].length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Text(
                                "Pris : " +
                                        appGet.searchList["prices"][index]
                                                ["price"]
                                            .toString() ??
                                    "" +
                                        " " +
                                        appGet.searchList["prices"][index]
                                            ["unit"] ??
                                    "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF414040),
                                ),
                              ),
                            );
                          }),
                    ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: appGet.noteController.value,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: "Note",
                  prefixIcon: Icon(
                    Icons.search,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 2,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(1),
                    ),
                  ),
                  fillColor: Colors.black,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      appGet.noteController.value.text = '';
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton(
                        color: AppColors.primary2,
                        onPressed: () async {
                          print("sssss");
                          await ApiServer.instance.getUpdateCheck(
                              appGet.searchList["id"],
                              1,
                              appGet.noteController.value.text ?? "");
                          Get.back();
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');

                          setToast("Problem", color: Colors.red);
                        },
                        child: Text(
                          "Problem",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                    FlatButton(
                        color: Colors.green,
                        onPressed: () async {
                          await ApiServer.instance.getUpdateCheck(
                              appGet.searchList["id"],
                              2,
                              appGet.noteController.value.text ?? "");
                          Get.back();
                          setToast(
                            "Ferdig",
                            color: Colors.green,
                          );
                        },
                        child: Text(
                          "Ferdig",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
