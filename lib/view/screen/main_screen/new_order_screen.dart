import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/Controller/getxController/getx.dart';
import 'package:dinengros/value/animate_do.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dinengros/view/widget/custom_text.dart';
import 'package:dinengros/view/widget/isload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<NewOrderScreen> {
  AppGet appGet = Get.find();
  GlobalKey<FormState> keyAdd = GlobalKey<FormState>();
  AnimationController animationController;
  bool visable = true;
  int idProduct = 1;
  String nameUitel;
  String nameProduct;
  int unitId;
  String unit = '';
  int qty;
  String name;
  double total = 0.0;
  static const double padding = 20;

  List<double> listWeight;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    appGet.newOrderFocus.unfocus();
    appGet.idUserController.value.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Background(
          notfi: true,
          back: true,
          user: true,
          contant: Obx(() {
            return SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  child: TextField(
                    controller: appGet.newOrderController.value,
                    autofocus: kReleaseMode,
                    focusNode: appGet.newOrderFocus,
                    decoration: InputDecoration(
                      hintText: "Strekkode",
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 13,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            )),
                        onPressed: () {
                          appGet.newOrderController.value.text = "";
                          // appGet.barCodeFocus.unfocus();
                        },
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    appGet.searchList.clear();
                    await appGet
                        .getPostApi(appGet.newOrderController.value.text);
                    await ApiServer.instance
                        .getSearchProduct(appGet.content01.value);

                    if (appGet.searchList["barcode"] ==
                        appGet.content01.value) {
                      if (appGet.listAddProduct.length == 0) {
                        if (appGet.searchList['selected_unit'] == 2) {
                          showMainDialog(onTap: () {
                            addList(
                                quantity: int.parse(
                                    appGet.quantityController.value.text));
                            Get.back();
                          });
                        } else {
                          addList(quantity: 1);
                        }
                      } else {
                        // print(appGet.listAddProduct[0].toJson());
                        // print(appGet.listAddProduct[1].toJson());
                        List<ProductModel> productModel2 = [];
                        productModel2 = appGet.listAddProduct
                            .where((e) =>
                                e.idProduct == appGet.searchList["id"] &&
                                e.idUnit == appGet.searchList["selected_unit"])
                            .toList();
                        if (productModel2.length == 0) {
                          if (appGet.searchList['selected_unit'] == 2) {
                            showMainDialog(onTap: () {
                              addList(
                                quantity: int.parse(
                                    appGet.quantityController.value.text),
                              );
                              Get.back();
                            });
                          } else {
                            addList(quantity: 1);
                          }
                        } else {
                          if (productModel2[0].idProduct ==
                              appGet.searchList["id"]) {
                            print("......${appGet.searchList["id"]}");

                            if (appGet.searchList['selected_unit'] == 2) {
                              showMainDialog(
                                  qty: productModel2[0].quantity,
                                  onTap: () {
                                    appGet.listAddProduct.remove(productModel2);
                                    appGet.listInScreen.remove(productModel2);
                                    appGet.whereHousScreen
                                        .remove(productModel2);
                                    addList(
                                      quantity: int.parse(
                                          appGet.quantityController.value.text),
                                    );
                                    Get.back();
                                  });
                            } else {
                              addList(add: 0);
                            }
                          } else {
                            if (appGet.searchList['selected_unit'] == 2) {
                              showMainDialog(
                                  qty: productModel2[0].quantity,
                                  onTap: () {
                                    addList(
                                      quantity: int.parse(
                                          appGet.quantityController.value.text),
                                    );
                                    Get.back();
                                  });
                            } else {
                              addList(quantity: 1);
                            }
                          }
                        }
                      }
                    } else {
                      setToast("Varen ble ikke funnet", color: Colors.red);
                    }

                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                        height: 25.h,
                        width: 280.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.primary2,
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
                appGet.listAddProduct.length != 0
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Container(
                            height: Get.height / 1.5.h,
                            child: ListView.separated(
                              separatorBuilder: (_, index2) =>
                                  SizedBox(height: 2),
                              itemCount: appGet.listAddProduct.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index2) => InkWell(
                                onTap: () {
                                  appGet.listAddProduct[index2].idUnit == 2
                                      ? Container()
                                      : showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          useRootNavigator: true,
                                          isDismissible: true,
                                          builder: (context) {
                                            print(appGet.listInScreen[index2]
                                                .idProduct);
                                            List<ProductModel> listBottom =
                                                appGet.listInScreen
                                                    .where((e) =>
                                                        e.idProduct ==
                                                        appGet
                                                            .listAddProduct[
                                                                index2]
                                                            .idProduct)
                                                    .toList();
                                            print(listBottom[0].toJson());
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.r),
                                                ),
                                              ),
                                              child: SizedBox(
                                                  height: 300.h,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        listBottom.length,
                                                    padding:
                                                        EdgeInsets.all(6.0),
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Container(
                                                        // height: 42.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .doneColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                6.r),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 2.w,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(2),
                                                                    child: Text(
                                                                      listBottom[index]
                                                                              .nameProduct ??
                                                                          "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.sp,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 2.w,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        4),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    // Spacer(),

                                                                    Column(
                                                                      children: [
                                                                        Text(
                                                                          "Batch / S.N",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                        Text(
                                                                          listBottom[index].batch ??
                                                                              "",
                                                                          // appGet.idlist.contains(index2)
                                                                          //     ? appGet.batchNum[index2]
                                                                          //             .toString() ??
                                                                          //         ""
                                                                          //     : "",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Spacer(),
                                                                    Column(
                                                                      children: [
                                                                        Text(
                                                                          "unit",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                        Text(
                                                                          listBottom[index].unit ??
                                                                              "",
                                                                          // appGet.idlist.contains(index2)
                                                                          //     ? appGet.exdate[index2]
                                                                          //             .toString()
                                                                          //             .substring(0, 10) ??
                                                                          //         ""
                                                                          //     : "",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    Spacer(),

                                                                    Column(
                                                                      children: [
                                                                        Text(
                                                                          "Vekt",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                        Text(
                                                                          listBottom[index].kello ??
                                                                              "",
                                                                          // appGet.idlist.contains(index2)
                                                                          //     ? appGet.kello[index2]
                                                                          //             .toString() ??
                                                                          //         ""
                                                                          //     : "",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          },
                                        );
                                },
                                child: FadeIn(
                                  duration: const Duration(milliseconds: 600),
                                  child: Dismissible(
                                    direction: DismissDirection.endToStart,
                                    background: Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.w,
                                          bottom: 10.h,
                                          top: 2.h,
                                          right: 8.w),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            // boxShadow: sShadow1,
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10)),

                                        // color: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              CustomText(
                                                'Delete'.tr,
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    key: UniqueKey(),
                                    onDismissed: (DismissDirection direction) {
                                      appGet.listInScreen.removeWhere((e) =>
                                          e.idProduct ==
                                          appGet.listAddProduct[index2]
                                              .idProduct);
                                      appGet.listAddProduct.removeAt(index2);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Container(
                                        // height: 35.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.doneColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    appGet
                                                                .listAddProduct[
                                                                    index2]
                                                                .idUnit ==
                                                            2
                                                        ? " " +
                                                            appGet
                                                                .listAddProduct[
                                                                    index2]
                                                                .quantity
                                                                .toString() +
                                                            " X "
                                                        : " " +
                                                            appGet.listInScreen
                                                                .where((e) =>
                                                                    e.idProduct ==
                                                                    appGet
                                                                        .listAddProduct[
                                                                            index2]
                                                                        .idProduct)
                                                                .toList()
                                                                .length
                                                                .toString() +
                                                            " X ",
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    // width: 300.w,
                                                    child: Text(
                                                      appGet
                                                              .listAddProduct[
                                                                  index2]
                                                              .nameProduct ??
                                                          "",
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              // Spacer(),
                                              Text(
                                                appGet.listAddProduct[index2]
                                                    .unit,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xffA9AAAA),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 1.w,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Du må legge til produktene dine",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
             appGet.whereHousScreen.length==0?Container():   FlatButton(
                    onPressed: () async {
                      if (appGet.idUserController.value.text == "") {
                        setToast("Kunden må velge", color: Colors.red);
                      } else {
                        if (appGet.listAddProduct.isEmpty) {
                          setToast("Produkter må legges til",
                              color: Colors.red);
                        } else {
                          print(appGet.whereHousScreen[0].toJson());
                          await ApiServer.instance.getCreatOrder(
                            userId: int.parse(
                                appGet.idUserController.value.text.toString()),
                            whereHous: appGet.whereHousScreen,
                          );
                              appGet.userController.value.text = "";

                        }
                      }
                    },
                    child: Container(
                      height: 30.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green),
                      child: Center(
                          child: Text(
                        "Ferdig",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    )),
              ],
            ));
          }),
        ));
  }

  void addList({
    int quantity = 1,
    int add = 1,
  }) {
    add == 1
        ? appGet.listAddProduct.add(ProductModel(
            idProduct: appGet.searchList["id"],
            nameProduct: appGet.searchList["name"],
            quantity: quantity,
            idUnit: appGet.searchList["selected_unit"],
            unit: appGet.searchList["selected_unit_name"],
            kello: appGet.content310.value.toString() ?? "",
            batch: appGet.content10.value ?? ""))
        : null;
    appGet.listInScreen.add(ProductModel(
        idProduct: appGet.searchList["id"],
        nameProduct: appGet.searchList["name"],
        quantity: quantity,
        idUnit: appGet.searchList["selected_unit"],
        unit: appGet.searchList["selected_unit_name"],
        kello: appGet.content310.value.toString() ?? "",
        batch: appGet.content10.value ?? ""));
    appGet.whereHousScreen.add(WhereHouseModel(
        afterBarcod: appGet.newOrderController.value.text,
        barcode: appGet.content01.value,
        idProduct: appGet.searchList["id"],
        price: double.parse(appGet.searchList["price"] ?? "0"),
        discount: 0,
        nameProduct: appGet.searchList["name"],
        quantity: quantity,
        idUnit: appGet.searchList["selected_unit"],
        unit: appGet.searchList["selected_unit_name"],
        kello: appGet.content310.value.toString() ?? "",
        batch: appGet.content10.value ?? "",
        date: appGet.content17.value ?? ""));
    setToast("Done");
    appGet.newOrderController.value.text = "";
    appGet.quantityController.value.text = "";
  }

  void showMainDialog({int qty = 0, Function onTap}) {
    showDialog(
      context: Get.context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: StatefulBuilder(
            builder: (ctx, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                      child: Text(
                    "$qty",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  TextField(
                    controller: appGet.quantityController.value,
                    enabled: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Antall',
                    ),
                  ),
                  RaisedButton(
                    color: Colors.green,
                    onPressed: onTap,
                    child: Text(
                      'Ferdig',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              '1',
                              textAlign: TextAlign.center,
                              style: style,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text =
                                appGet.quantityController.value.text + '1';
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              '2',
                              textAlign: TextAlign.center,
                              style: style,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text =
                                appGet.quantityController.value.text + '2';
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              '3',
                              textAlign: TextAlign.center,
                              style: style,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text =
                                appGet.quantityController.value.text + '3';
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              '4',
                              textAlign: TextAlign.center,
                              style: style,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text =
                                appGet.quantityController.value.text + '4';
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              '5',
                              textAlign: TextAlign.center,
                              style: style,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text =
                                appGet.quantityController.value.text + '5';
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              '6',
                              textAlign: TextAlign.center,
                              style: style,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text =
                                appGet.quantityController.value.text + '6';
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              '7',
                              textAlign: TextAlign.center,
                              style: style,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text =
                                appGet.quantityController.value.text + '7';
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              '8',
                              textAlign: TextAlign.center,
                              style: style,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text =
                                appGet.quantityController.value.text + '8';
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              '9',
                              textAlign: TextAlign.center,
                              style: style,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text =
                                appGet.quantityController.value.text + '9';
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              'CLR',
                              // style: TextStyle(color: Colors.red),
                              style: style.copyWith(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text = '';
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              '0',
                              textAlign: TextAlign.center,
                              style: style,
                            ),
                          ),
                          onTap: () {
                            appGet.quantityController.value.text =
                                appGet.quantityController.value.text + '0';
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(
                              'DEL',
                              textAlign: TextAlign.center,
                              style: style.copyWith(color: Colors.red),
                            ),
                          ),
                          onTap: () {
                            if (appGet
                                .quantityController.value.text.isNotEmpty) {
                              appGet.quantityController.value.text = appGet
                                  .quantityController.value.text
                                  .substring(
                                      0,
                                      appGet.quantityController.value.text
                                              .length -
                                          1);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProductModel {
  final int idProduct, quantity, idUnit;
  final String nameProduct, kello, batch, unit;

  ProductModel(
      {this.idProduct,
      this.nameProduct,
      this.quantity,
      this.kello,
      this.idUnit,
      this.unit,
      this.batch});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.idProduct;
    data['qty'] = this.quantity;
    data['kello'] = this.kello;
    data['discount'] = 0;
    data['unit_id'] = this.idUnit;

    return data;
  }
}

class WhereHouseModel {
  final int idProduct, quantity, idUnit, stkCount, discount;
  final double price;
  final String nameProduct, kello, batch, unit, barcode, afterBarcod, date;

  WhereHouseModel(
      {this.discount,
      this.price,
      this.idProduct,
      this.nameProduct,
      this.quantity,
      this.kello,
      this.idUnit,
      this.barcode,
      this.stkCount,
      this.date,
      this.afterBarcod,
      this.unit,
      this.batch});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['product_id'] = this.idProduct;
    data['price'] = this.price;
    data['discount'] = this.discount ?? "0";
    data['qty'] = this.quantity;
    data['expiration_date'] = this.kello;
    data['barcode'] = this.barcode;
    data['unit_id'] = this.idUnit;
    data['stk_count'] = this.stkCount ?? 0;
    data['batch_num'] = this.batch;
    data['weight'] = this.kello;
    data['production_date'] = this.date;
    data['expiration_date'] = this.date;
    data['barcode_after_analyz'] = this.afterBarcod;

    return data;
  }
}
