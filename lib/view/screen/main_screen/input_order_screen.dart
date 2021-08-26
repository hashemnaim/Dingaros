import 'dart:io';
import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/Controller/getxController/getx.dart';
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
  AppGet appGet = Get.find();

  @override
  void initState() {
    appGet.inputFocus.unfocus();

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SearchChoices.single(
                    // readOnly:true,
                    autofocus: false,
                    items: appGet.listProduct.map((value) {
                      return (DropdownMenuItem(
                        child: Text(value["name"].toString()),
                        value: value,
                      ));
                    }).toList(),
                    value: selectedProduct.isEmpty
                        ? "select Product"
                        : selectedProduct,
                    hint: selectedProduct.isEmpty
                        ? "select Product"
                        : Text(
                            selectedProduct,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                    onChanged: (value) {
                      setState(() {
                        selectedProduct = value['name'].toString();
                        selectedProductID = value['id'];
                      });
                    },

                    dialogBox: false,
                    isExpanded: true,
                    menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
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
                        // searchHint: selectedValueSingleMenu,
                        onChanged: (value) {
                          setState(() {
                            type = value["name"].toString();
                            typeId = value["id"];
                            // print(type.toString());
                            // print(typeId.toString());
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
                      autofocus: kReleaseMode,
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
                  InkWell(
                    onTap: () async {
                      await appGet
                          .getPostApi(appGet.barCodeInputController.value.text);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: null)),
                  ),
                  appGet.lodaing.value != false
                      ? IsLoad()
                      : appGet.groupApi.value == "A"
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
                                  Text(appGet.barcodValue.value,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          : appGet.productList.value.isEmpty ||
                                  appGet.productList.value.length == 0
                              ? Container()
                              : Container(
                                  height: 80,
                                  child: ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      itemCount: appGet.productList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                  appGet.product["name" +
                                                              appGet.productList[
                                                                  index]]
                                                          .toString() +
                                                      " : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12)),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                  appGet.product["content" +
                                                          appGet.productList[
                                                              index]]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        );
                                      }),
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
        ));
    // floatingActionButton: FloatingCustom());
  }

  void save() async {

    // if(appGet.listProduct)
    await ApiServer.instance
        .getSaveOrder(
            productId: selectedProductID,
            unitId: typeId,
            barcode: appGet.content01.value,
            pdate: appGet.content17.value,
            barcodeAfter: appGet.barCodeInputController.value.text,
            exdate: appGet.content17.value,
            batchNum: appGet.content10.value,
            moveType: "input",
            qty: 1,
            productName: selectedProduct,
            kilo: appGet.content310.value.toString())
        .then((value) {
      selectedProduct = "";
      type = "";

      appGet.barCodeInputController.value.text = "";
      appGet.productList.value = [];
      appGet.product.value.clear();
      // setState(() {});
    });
  }
}
