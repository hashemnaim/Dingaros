import 'dart:io';
import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/widget/custom_button.dart';
import 'package:dinengros/view/widget/custom_image.dart';
import 'package:dinengros/view/widget/custom_text.dart';
import 'package:dinengros/view/widget/isload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SingingCharacter { Stk, Kg, Eske }

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({
    Key key,
  }) : super(key: key);
  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<AddProductScreen> {
  bool focused = true;

  List<String> listMonth = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
  ];
  List<String> listDays = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31",
  ];
  List<String> listYear = [
    (DateTime.now().year - 2).toString(),
    (DateTime.now().year - 1).toString(),
    (DateTime.now().year).toString(),
    (DateTime.now().year + 1).toString(),
    (DateTime.now().year + 2).toString(),
    (DateTime.now().year + 3).toString(),
    (DateTime.now().year + 4).toString(),
    (DateTime.now().year + 5).toString(),
  ];
  FocusNode focusbatch = FocusNode();
  FocusNode focusBarCod = FocusNode();

  AppController appGet = Get.find();
  TextEditingController contantBarCodeController = TextEditingController();
  TextEditingController content17 = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController content37 = TextEditingController();
  TextEditingController contant13 = TextEditingController();
  TextEditingController contant21 = TextEditingController();
  TextEditingController content310 = TextEditingController();
  TextEditingController content10 = TextEditingController();
  TextEditingController nameProductController = TextEditingController();
  TextEditingController qtyController = TextEditingController(text: "1");

  textClear() {
    appGet.productList.clear();
    appGet.type.value = "";

    content37.text = "";
    content17.text = "";
    contant13.text = "";
    contant21.text = "";
    content310.text = "";
    content10.text = "";
    appGet.content10.value = "";
    appGet.content17.value = "";
    qtyController.text = "1";
    appGet.nameAddProductController.value.text = "";
    appGet.eFTAController.value.text = "";
    appGet.tEMPERATURController.value.text = "";
    appGet.product.clear();
    appGet.content310.value = "";
    appGet.batchNew.value.text = "";
    appGet.content10New.value = "";
    nameProductController.text = "";
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  // SingingCharacter character = SingingCharacter.Stk;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1)).then(
        (value) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: AppColors.primary2,
        leading: GestureDetector(
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
        title: CustomPngImage(
          imageName: "mini_logo",
          fit: BoxFit.contain,
          width: 70.w,
          height: 70.h,
        ),
        centerTitle: true,
      ),
      body:
          //  Obx(
          //   () =>
          Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Container(
          // height: 400,
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        // height: 50.h,
                        // width: 400.w,

                        child: TextFormField(
                          controller: appGet.barCodeAddProductController.value,
                          autofocus: true,
                          focusNode: focusBarCod,
                          // maxLines: null,
                          // minLines: 1,
                          onFieldSubmitted: (v) async {
                            appGet.kelloId.value !=
                                    appGet
                                        .barCodeAddProductController.value.text
                                ? appGet.chackello.value = false
                                : appGet.chackello.value =
                                    appGet.chackello.value;
                            appGet.content310.value == ""
                                ? appGet.kelloId.value ==
                                        appGet.barCodeAddProductController.value
                                            .text
                                    ? appGet.chackello.value == true
                                        ? null
                                        : textClear()
                                    : textClear()
                                : textClear();

                            // await Future.delayed(Duration(milliseconds: 300));
                            await appGet.getPostApi(
                                appGet.barCodeAddProductController.value.text);
                            appGet.nameAddProductController.value.text =
                                appGet.productName.value;
                            setState(() {});
                          },

                          decoration: InputDecoration(
                            hintText: "Barcode",
                            prefixIcon: Icon(
                              Icons.search,
                            ),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            fillColor: Colors.grey[200],
                            suffixIcon: IconButton(
                              icon: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  )),
                              onPressed: () {
                                appGet.content310.value == ""
                                    ? appGet.kelloId.value ==
                                            appGet.barCodeAddProductController
                                                .value.text
                                        ? appGet.chackello.value == true
                                            ? null
                                            : textClear()
                                        : textClear()
                                    : textClear();
                                appGet.barCodeAddProductController.value.text =
                                    "";
                                focusBarCod.requestFocus();

                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () async {
                            appGet.content310.value == ""
                                ? appGet.kelloId.value ==
                                        appGet.barCodeAddProductController.value
                                            .text
                                    ? appGet.chackello.value == true
                                        ? null
                                        : textClear()
                                    : textClear()
                                : textClear();

                            await appGet.getPostApi(
                                appGet.barCodeAddProductController.value.text);
                            appGet.nameAddProductController.value.text =
                                appGet.productName.value;

                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            // width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                appGet.barCodeAddProductController.value.text == ''
                    ? Container()
                    : appGet.lodaing.value != false
                        ? IsLoad()
                        : appGet.groupApi.value == "A"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                              appGet.groupApi.value + " : ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16)),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            // height: 25.h,
                                            width: 90.w,
                                            child: TextFormField(
                                              maxLines: null,
                                              minLines: 1,
                                              controller:
                                                  contantBarCodeController
                                                    ..text =
                                                        appGet.content01.value,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                hintText: "Navn",
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                fillColor: Colors.grey[200],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16.h,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text("Navn " + " : ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16)),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            // height: 25.h,
                                            width: 90.w,
                                            child: TextFormField(
                                              maxLines: null,
                                              minLines: 1,
                                              controller: appGet
                                                  .nameAddProductController
                                                  .value,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                hintText: "Navn",
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                fillColor: Colors.grey[200],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    appGet.barCodeAddProductController.value
                                                .text ==
                                            ""
                                        ? Container()
                                        : appGet.content17.value != ""
                                            ? Container()
                                            : Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                        "ExpDate" + " : ",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15)),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      // height: 25.h,
                                                      // width: 90.w,
                                                      child: InkWell(
                                                        // initialValue: "",
                                                        onTap: () {
                                                          SystemChannels
                                                              .textInput
                                                              .invokeMethod(
                                                                  'TextInput.hide');

                                                          Get.defaultDialog(
                                                              title: "Year",
                                                              middleText: "",
                                                              content:
                                                                  SingleChildScrollView(
                                                                child: Wrap(
                                                                  children: List
                                                                      .generate(
                                                                          listYear
                                                                              .length,
                                                                          (index) =>
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');

                                                                                  content17.text = listYear[index];
                                                                                  Get.back();
                                                                                  Get.defaultDialog(
                                                                                      title: "Month",
                                                                                      middleText: "",
                                                                                      content: Wrap(
                                                                                        children: List.generate(
                                                                                            listMonth.length,
                                                                                            (index) => InkWell(
                                                                                                  onTap: () {
                                                                                                    Get.back();
                                                                                                    SystemChannels.textInput.invokeMethod('TextInput.hide');

                                                                                                    content17.text = content17.text + "-" + listMonth[index];

                                                                                                    Get.defaultDialog(
                                                                                                        title: "Days",
                                                                                                        middleText: "",
                                                                                                        content: Wrap(
                                                                                                          children: List.generate(
                                                                                                              listDays.length,
                                                                                                              (index) => InkWell(
                                                                                                                    onTap: () {
                                                                                                                      SystemChannels.textInput.invokeMethod('TextInput.hide');

                                                                                                                      content17.text = content17.text + "-" + listDays[index];
                                                                                                                      focusbatch.requestFocus();
                                                                                                                      setState(() {});
                                                                                                                      Get.back();
                                                                                                                    },
                                                                                                                    child: Padding(
                                                                                                                      padding: const EdgeInsets.all(10.0),
                                                                                                                      child: Container(
                                                                                                                          height: 45,
                                                                                                                          width: 45,
                                                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
                                                                                                                            BoxShadow(color: Colors.grey, offset: Offset(1, 2), blurRadius: 8, spreadRadius: 4)
                                                                                                                          ]),
                                                                                                                          child: Padding(
                                                                                                                            padding: const EdgeInsets.all(10.0),
                                                                                                                            child: Center(
                                                                                                                              child: CustomText(
                                                                                                                                listDays[index],
                                                                                                                                fontSize: 18,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          )),
                                                                                                                    ),
                                                                                                                  )),
                                                                                                        ));
                                                                                                  },
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(10.0),
                                                                                                    child: Container(
                                                                                                        height: 70,
                                                                                                        width: 55,
                                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
                                                                                                          BoxShadow(color: Colors.grey, offset: Offset(1, 2), blurRadius: 8, spreadRadius: 4)
                                                                                                        ]),
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.all(10.0),
                                                                                                          child: Center(
                                                                                                            child: CustomText(
                                                                                                              listMonth[index],
                                                                                                              fontSize: 24,
                                                                                                            ),
                                                                                                          ),
                                                                                                        )),
                                                                                                  ),
                                                                                                )),
                                                                                      ));
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Container(
                                                                                      height: 100,
                                                                                      width: 100,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
                                                                                        BoxShadow(color: Colors.grey, offset: Offset(1, 2), blurRadius: 8, spreadRadius: 4)
                                                                                      ]),
                                                                                      child: Center(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: CustomText(
                                                                                            listYear[index],
                                                                                            fontSize: 28,
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                ),
                                                                              )),
                                                                ),
                                                              ));
                                                        },

                                                        child: Container(
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    CustomText(
                                                                  content17
                                                                      .text,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    appGet.barCodeAddProductController.value
                                                .text ==
                                            ""
                                        ? Container()
                                        : appGet.content10.value != ""
                                            ? Container()
                                            : Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                        "Batch No" + " : ",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15)),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller: appGet
                                                            .batchNew.value,
                                                        // ..text = appGet
                                                        //     .content10New
                                                        //     .value,
                                                        focusNode: focusbatch,
                                                        onFieldSubmitted:
                                                            (v) async {
                                                          await Future.delayed(
                                                              Duration(
                                                                  milliseconds:
                                                                      300));
                                                          appGet.batchNew.value
                                                              .text = "";
                                                          await ApiServer
                                                              .instance
                                                              .getReaderBarcodeBatch(
                                                                  appGet
                                                                      .batchNew
                                                                      .value
                                                                      .text);
                                                        },

                                                        maxLines: null,
                                                        minLines: 1,

                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          hintText: "Batch No",
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .grey[500]),
                                                          filled: true,
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10),
                                                            ),
                                                          ),
                                                          fillColor:
                                                              Colors.grey[200],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  appGet.productList.isEmpty ||
                                          appGet.productList.length == 0
                                      ? Container()
                                      : Column(
                                          children: [
                                            SizedBox(
                                              height: 4.h,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text("ID" + " : ",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15)),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    // height: 25.h,
                                                    width: 90.w,
                                                    child: TextFormField(
                                                      maxLines: null,
                                                      minLines: 1,
                                                      controller:
                                                          contantBarCodeController
                                                            ..text = appGet
                                                                    .product[
                                                                "content01"],
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        hintText: "Navn",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400]),
                                                        filled: true,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        fillColor:
                                                            Colors.grey[200],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text("Navn " + " : ",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16)),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    // height: 25.h,
                                                    width: 90.w,
                                                    child: TextFormField(
                                                      controller: appGet
                                                          .nameAddProductController
                                                          .value,
                                                      maxLines: null,
                                                      minLines: 1,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        hintText: "Navn",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400]),
                                                        filled: true,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        fillColor:
                                                            Colors.grey[200],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            appGet.content17.value != ""
                                                ? Container()
                                                : SizedBox(
                                                    height: 10.h,
                                                  ),
                                            appGet.barCodeAddProductController
                                                        .value.text ==
                                                    ""
                                                ? Container()
                                                : appGet.content17.value != ""
                                                    ? Container()
                                                    : Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                                "ExpDate" +
                                                                    " : ",
                                                                style: TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15)),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              // height: 25.h,
                                                              // width: 90.w,
                                                              child: InkWell(
                                                                // initialValue: "",
                                                                onTap: () {
                                                                  SystemChannels
                                                                      .textInput
                                                                      .invokeMethod(
                                                                          'TextInput.hide');

                                                                  Get.defaultDialog(
                                                                      title: "Year",
                                                                      middleText: "",
                                                                      content: SingleChildScrollView(
                                                                        child:
                                                                            Wrap(
                                                                          children: List.generate(
                                                                              listYear.length,
                                                                              (index) => InkWell(
                                                                                    onTap: () {
                                                                                      SystemChannels.textInput.invokeMethod('TextInput.hide');

                                                                                      content17.text = listYear[index];
                                                                                      Get.back();
                                                                                      Get.defaultDialog(
                                                                                          title: "Month",
                                                                                          middleText: "",
                                                                                          content: Wrap(
                                                                                            children: List.generate(
                                                                                                listMonth.length,
                                                                                                (index) => InkWell(
                                                                                                      onTap: () {
                                                                                                        Get.back();
                                                                                                        SystemChannels.textInput.invokeMethod('TextInput.hide');

                                                                                                        content17.text = content17.text + "-" + listMonth[index];

                                                                                                        Get.defaultDialog(
                                                                                                            title: "Days",
                                                                                                            middleText: "",
                                                                                                            content: Wrap(
                                                                                                              children: List.generate(
                                                                                                                  listDays.length,
                                                                                                                  (index) => InkWell(
                                                                                                                        onTap: () {
                                                                                                                          SystemChannels.textInput.invokeMethod('TextInput.hide');

                                                                                                                          content17.text = content17.text + "-" + listDays[index];
                                                                                                                          focusbatch.requestFocus();
                                                                                                                          setState(() {});
                                                                                                                          Get.back();
                                                                                                                        },
                                                                                                                        child: Padding(
                                                                                                                          padding: const EdgeInsets.all(10.0),
                                                                                                                          child: Container(
                                                                                                                              height: 45,
                                                                                                                              width: 45,
                                                                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
                                                                                                                                BoxShadow(color: Colors.grey, offset: Offset(1, 2), blurRadius: 8, spreadRadius: 4)
                                                                                                                              ]),
                                                                                                                              child: Padding(
                                                                                                                                padding: const EdgeInsets.all(10.0),
                                                                                                                                child: Center(
                                                                                                                                  child: CustomText(
                                                                                                                                    listDays[index],
                                                                                                                                    fontSize: 18,
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              )),
                                                                                                                        ),
                                                                                                                      )),
                                                                                                            ));
                                                                                                      },
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.all(10.0),
                                                                                                        child: Container(
                                                                                                            height: 70,
                                                                                                            width: 55,
                                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
                                                                                                              BoxShadow(color: Colors.grey, offset: Offset(1, 2), blurRadius: 8, spreadRadius: 4)
                                                                                                            ]),
                                                                                                            child: Padding(
                                                                                                              padding: const EdgeInsets.all(10.0),
                                                                                                              child: Center(
                                                                                                                child: CustomText(
                                                                                                                  listMonth[index],
                                                                                                                  fontSize: 24,
                                                                                                                ),
                                                                                                              ),
                                                                                                            )),
                                                                                                      ),
                                                                                                    )),
                                                                                          ));
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Container(
                                                                                          height: 100,
                                                                                          width: 100,
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
                                                                                            BoxShadow(color: Colors.grey, offset: Offset(1, 2), blurRadius: 8, spreadRadius: 4)
                                                                                          ]),
                                                                                          child: Center(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(12.0),
                                                                                              child: CustomText(
                                                                                                listYear[index],
                                                                                                fontSize: 28,
                                                                                              ),
                                                                                            ),
                                                                                          )),
                                                                                    ),
                                                                                  )),
                                                                        ),
                                                                      ));
                                                                },

                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                              .grey[
                                                                          200],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            CustomText(
                                                                          content17
                                                                              .text,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          color:
                                                                              Colors.black87,
                                                                        ),
                                                                      )),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                            appGet.content10.value != ""
                                                ? Container()
                                                : SizedBox(
                                                    height: 10.h,
                                                  ),
                                            appGet.barCodeAddProductController
                                                        .value.text ==
                                                    ""
                                                ? Container()
                                                : appGet.content10.value != ""
                                                    ? Container()
                                                    : Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                                "Batch No" +
                                                                    " : ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15)),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                controller:
                                                                    appGet
                                                                        .batchNew
                                                                        .value,
                                                                focusNode:
                                                                    focusbatch,
                                                                onFieldSubmitted:
                                                                    (v) async {
                                                                  await Future.delayed(
                                                                      Duration(
                                                                          milliseconds:
                                                                              300));

                                                                  await ApiServer
                                                                      .instance
                                                                      .getReaderBarcodeBatch(appGet
                                                                          .batchNew
                                                                          .value
                                                                          .text);
                                                                },
                                                                maxLines: null,
                                                                minLines: 1,
                                                                decoration:
                                                                    InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  hintText:
                                                                      "Batch No",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          500]),
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          10),
                                                                    ),
                                                                  ),
                                                                  fillColor:
                                                                      Colors.grey[
                                                                          200],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                            SizedBox(
                                              height: 4.h,
                                            ),
                                            Container(
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  padding: EdgeInsets.all(0),
                                                  itemCount: appGet
                                                          .productList.length -
                                                      1,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return appGet
                                                                .product["name" +
                                                                    appGet.productList[
                                                                        index +
                                                                            1]]
                                                                .toString() ==
                                                            "VARIANT"
                                                        ? Container()
                                                        : appGet.product["name" +
                                                                    appGet.productList[
                                                                        index +
                                                                            1]] ==
                                                                null
                                                            ? Container()
                                                            : Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                          appGet.product["name" + appGet.productList[index + 1]].toString() +
                                                                              " : ",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.black,
                                                                              fontSize: 15)),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Container(
                                                                        // height: 25.h,
                                                                        width:
                                                                            130.w,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: TextFormField(
                                                                                maxLines: null,
                                                                                minLines: 1,
                                                                                controller: appGet.productList[index + 1] == "10"
                                                                                    ? appGet.batchNew.value
                                                                                    : appGet.productList[index + 1] == "17" || appGet.productList[index + 1] == "15"
                                                                                        ? content17
                                                                                        : appGet.productList[index + 1] == "13"
                                                                                            ? contant13
                                                                                            : appGet.productList[index + 1] == "37"
                                                                                                ? content37
                                                                                                : appGet.productList[index + 1] == "310"
                                                                                                    ? content310
                                                                                                    : appGet.productList[index + 1] == "21"
                                                                                                        ? contant21
                                                                                                        : content
                                                                                  ..text = appGet.product["content" + appGet.productList[index + 1]],
                                                                                keyboardType: TextInputType.text,
                                                                                decoration: InputDecoration(
                                                                                  contentPadding: EdgeInsets.all(10),
                                                                                  hintText: appGet.product["name" + appGet.productList[index + 1]].toString(),
                                                                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                                                                  filled: true,
                                                                                  border: OutlineInputBorder(
                                                                                    borderSide: BorderSide.none,
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(10),
                                                                                    ),
                                                                                  ),
                                                                                  fillColor: Colors.grey[200],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            appGet.productList[index + 1] == "310"
                                                                                ? Checkbox(
                                                                                    value: appGet.chackello.value,
                                                                                    onChanged: (v) {
                                                                                      appGet.chackello.value = v;
                                                                                      appGet.kelloId.value = appGet.barCodeAddProductController.value.text;
                                                                                      // setState(() {});
                                                                                    },
                                                                                  )
                                                                                : Container(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                  }),
                                            ),
                                          ],
                                        ),

                                  // SizedBox(
                                  //   height: 10.h,
                                  // ),
                                ],
                              ),
                appGet.foundProduct.value == 1
                    ? Container()
                    : SizedBox(
                        height: 8.h,
                      ),
                appGet.barCodeAddProductController.value.text == ""
                    ? Container()
                    : appGet.foundProduct.value == 1
                        ? Container()
                        : Container(
                            height: 40,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                ...List.generate(
                                  appGet.listUnit.length,
                                  (index) => Expanded(
                                    child: Obx(() => Row(
                                          children: [
                                            Radio<int>(
                                              // title: CustomText(
                                              //   'Stk',
                                              //   fontSize: 14,
                                              //   fontWeight: FontWeight.w300,
                                              // ),
                                              // title: const Text('Norwegian'),
                                              value: appGet.typeId.value,
                                              groupValue: appGet.listUnit[index]
                                                  ['id'],
                                              onChanged: (int value) async {
                                                appGet.typeId.value = appGet
                                                    .listUnit[index]['id'];
                                                print(appGet.typeId.value);
                                                print(appGet.listUnit[index]
                                                    ['name']);
                                                // setState(() {

                                                // });
                                                // _character = SingingCharacter.Stk;
                                              },
                                            ),
                                            CustomText(
                                              appGet.listUnit[index]["name"],
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                SizedBox(
                  height: 8.h,
                ),
                appGet.barCodeAddProductController.value.text == ""
                    ? Container()
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("Efta" + " : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  // height: 25.h,
                                  width: 90.w,
                                  child: TextFormField(
                                    maxLines: null,
                                    minLines: 1,
                                    keyboardType: TextInputType.text,
                                    controller: appGet.eFTAController.value,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: "Efta",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      fillColor: Colors.grey[200],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("Temperatur" + " :",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  // height: 25.h,
                                  width: 90.w,
                                  child: TextFormField(
                                    maxLines: null,
                                    minLines: 1,
                                    keyboardType: TextInputType.number,
                                    controller:
                                        appGet.tEMPERATURController.value,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: "Temperatur",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      fillColor: Colors.grey[200],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("  " + "Antall" + " : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  // height: 25.h,
                                  // width: 90.w,
                                  child: TextFormField(
                                    controller: qtyController,
                                    keyboardType: TextInputType.number,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: "Antall",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      fillColor: Colors.grey[200],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 260,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: CustomButton(
                        text: appGet.foundProduct.value == 1
                            ? "Legg inn til lager"
                            : 'Legg til ny produkt',
                        onTap: () => save(),
                      ),
                    ),
                  ],
                )
             , SizedBox(
                  height: 8.h,
                ),
            
              ],
            ),
          ),
        ),
      ),
      // ),
    );
    // floatingActionButton: FloatingCustom());
  }

  void save() async {
    if (appGet.typeId.value == 0 && appGet.foundProduct.value == 0) {
      setToast("Velg type", color: Colors.red);
    } else {
      if (appGet.nameAddProductController.value.text == "" ||
          appGet.nameAddProductController.value.text == null) {
        setToast("Enter Product name", color: Colors.red);
      } else {
        if (qtyController.text == "") {
          setToast("Enter Qty ", color: Colors.red);
        } else {
          print(appGet.batchNew.value.text);
          await ApiServer.instance
              .getInput(
                  unitId: appGet.typeId.value,
                  barcode: appGet.groupApi.value == "A"
                      ? appGet.barCodeAddProductController.value.text
                      : contantBarCodeController.text,
                  pdate: contant13.text ?? "",
                  barcodeAfter: appGet.barCodeAddProductController.value.text,
                  exdate: content17.text ?? "",
                  batchNum: appGet.batchNew.value.text,
                  moveType: "input",
                  temperature: appGet.tEMPERATURController.value.text,
                  supplierNum: appGet.eFTAController.value.text,
                  stkcount: content37.text ?? "0",
                  qty: int.parse(qtyController.text) ?? "",
                  productName: appGet.nameAddProductController.value.text ?? "",
                  kilo: content310.text ?? "")
              .then((value) {
            appGet.chackello.value == true ? null : textClear();
            focusBarCod.requestFocus();
            appGet.barCodeAddProductController.value.text = '';
            setState(() {});
          });
        }
      }
    }
  }
}
