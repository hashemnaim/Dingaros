import 'dart:io';
import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/custom_button.dart';
import 'package:dinengros/view/widget/isload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:search_choices/search_choices.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputOrderScreen extends StatefulWidget {
  const InputOrderScreen({
    Key key,
  }) : super(key: key);
  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<InputOrderScreen> {
  String text = '';
  String selectedProduct = '';
  int selectedProductID = 0;
  String type = '';
  int typeId;
  File image;
  bool add = false;
  AppController appGet = Get.find();

  @override
  void initState() {
    appGet.productList.clear();
    appGet.barCodeInputController.value.text = "";
    Future.delayed(Duration(milliseconds: 1)).then(
        (value) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Background(
          notfi: true,
          back: true,
          contant: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SearchChoices.single(
                      // readOnly:true,
                      autofocus: false,
                      items: appGet.allProduct.value.data.map((value) {
                        return (DropdownMenuItem(
                          child: Text(value.name.toString()),
                          value: value.name,
                        ));
                      }).toList(),
                      value: selectedProduct.isEmpty
                          ? "select Product"
                          : selectedProduct,
                      hint: selectedProduct.isEmpty
                          ? "select Product"
                          : Text(
                              selectedProduct,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                      onChanged: (value) {
                        setState(() {
                          selectedProduct = value;
                          int i = appGet.allProduct.value.data
                              .indexWhere((element) => element.name == value);
                          selectedProductID =
                              appGet.allProduct.value.data[i].id;
                          print(selectedProductID);
                        });
                      },

                      dialogBox: false,
                      isExpanded: true,

                      menuConstraints:
                          BoxConstraints.tight(Size.fromHeight(350)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 34),
                      child: Container(
                        child: DropdownButton(
                          items: appGet.listUnit.map((value) {
                            return (DropdownMenuItem(
                              child: Text(value["name"].toString()),
                              value: value,
                            ));
                          }).toList(),
                          isExpanded: true,
                          // hint: appGet,
                          hint: type.isEmpty
                              ? Text("select type")
                              : Text(
                                  type,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                          onChanged: (value) {
                            setState(() {
                              type = value["name"].toString();
                              typeId = value["id"];
                            });
                          },
                        ),
                      ),
                    ),

                    Container(
                      height: 55.h,
                      width: 480.w,
                      child: TextFormField(
                        controller: appGet.barCodeInputController.value,
                        focusNode: appGet.inputFocus,
                        // autofocus: kReleaseMode,
                        onFieldSubmitted: (value) async {
                          await appGet.getPostApi(
                              appGet.barCodeInputController.value.text);
                          // setState(() {});
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
                              appGet.barCodeInputController.value.text = '';
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    // InkWell(
                    //   onTap: () async {

                    //   },
                    //   child: Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: Colors.black,
                    //       ),
                    //       child: IconButton(
                    //           icon: Icon(
                    //             Icons.arrow_forward,
                    //             color: Colors.white,
                    //           ),
                    //           onPressed: null)),
                    // ),

                    appGet.lodaing.value != false
                        ? IsLoad()
                        : appGet.groupApi.value == "A"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(appGet.groupApi.value + " : ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14)),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(appGet.barcodValue.value,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                    ),
                                  ],
                                ),
                              )
                            : appGet.productList.isEmpty ||
                                    appGet.productList.length == 0
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                                appGet.product["name01"],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14)),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                                appGet.product["content01"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        // height: 80,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            primary: false,
                                            padding: EdgeInsets.all(0),
                                            itemCount:
                                                appGet.productList.length - 1,
                                            itemBuilder: (context, index) {
                                              return appGet.product["content" +
                                                          appGet.productList[
                                                              index + 1]] ==
                                                      null
                                                  ? Container()
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                                appGet.product["name" +
                                                                            appGet.productList[index +
                                                                                1]]
                                                                        .toString() +
                                                                    " : ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14)),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                                appGet.product["content" +
                                                                            appGet.productList[index +
                                                                                1]]
                                                                        .toString() ??
                                                                    "",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                            }),
                                      ),
                                    ],
                                  ),

                    SizedBox(
                      height: 14,
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
                            text: 'Save',
                            onTap: () => save(),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
    // floatingActionButton: FloatingCustom());
  }

  void save() async {
    print(selectedProductID);
    if (appGet.barCodeInputController.value.text == "") {
      setToast("Enter Barcode", color: Colors.red);
    } else {
      await ApiServer.instance
          .getLink(
        unitId: typeId,
        barcode: appGet.content01.value,
        productId: selectedProductID,
      )
          .then((value) {
        selectedProduct = "";
        type = "";

        appGet.barCodeInputController.value.text = "";
        appGet.productList.clear();
        appGet.product.clear();
        setState(() {});
      });
    }
  }
}
