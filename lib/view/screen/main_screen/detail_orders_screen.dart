import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/customTextField.dart';
import 'package:dinengros/view/widget/isload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../Controller/getxController/getx.dart';
import 'Count_Kello_Screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsOrdersList extends StatefulWidget {
  final int indexOrder, statusId;
  const DetailsOrdersList({
    Key key,
    this.indexOrder,
    this.statusId,
  }) : super(key: key);
  @override
  _DetailsOrdersListState createState() => _DetailsOrdersListState();
}

class _DetailsOrdersListState extends State<DetailsOrdersList> {
  AppGet appGet = Get.find();
  int qty;
  int index;
  int selectedProductID;
  ScrollController scrollController = ScrollController();
  int unitId;
  String name;
  List listselect = [];
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    appGet.detailFocus.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    stautsList();
    super.initState();
  }

  check() {
    List list = appGet.listDetailsOrders[0]["orderDetails"]
        .where((element) => element["is_sacn_barcode"] == 0)
        .toList();

    int x = list.length == 0
        ? 0
        : list.length != appGet.listDetailsOrders[0]["orderDetails"]
            ? 1
            : 2;
    return x;
  }

  List listMap = [];
  stautsList() {
    List list = appGet.mapStatus["data"].sublist(1);
    listMap = list.where((e) => e["active"] == 1).toList();
    setState(() {});
    // return list.where((e) => e["active"] == 1).toList();
  }

  whereProduct(List list, List list2) async {
    if (list.length != 0) {
      if (list[0]["barcode"] == appGet.content01.value) {
        selectedProductID = list[0]["product_id"];
        unitId = list[0]["unit_id"];
        name = list[0]["product_name"];
        qty = list[0]["qty"];

        if (qty > 1) {
          appGet.qtynew.value = qty;
          appGet.kelloController.value.text = "";
          appGet.stkCountController.value.text = "";
          appGet.qtyindex.value = 0;
          appGet.stkCountController.value.text = qty.toString();
          if (unitId == 3) {
            Get.dialog(AlertDialog(
              title: Column(
                children: [
                  Text(
                    "$qty",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      FlatButton(
                          color: Colors.green,
                          onPressed: () async {
                            if (appGet.stkCountController.value.text ==
                                qty.toString()) {
                              await ApiServer.instance
                                  .getUpdateProductBarcode(list[0]["id"]);
                              await ApiServer.instance.getUpdateScanStatus(
                                  list[0]["id"],
                                  appGet.mapStatus["data"][0]["id"]);
                              appGet.save(
                                  qty,
                                  appGet.barCodeController.value.text,
                                  list[0]["id"],
                                  appGet.listDetailsOrders[0]["id"],
                                  selectedProductID,
                                  unitId,
                                  name);

                              appGet.barCodeController.value.text = "";

                              await ApiServer.instance.getDetailsOrders(
                                  appGet.listDetailsOrders[0]["id"]);

                              Navigator.pop(context);
                            } else {
                              setToast("Feil mengde", color: Colors.red);
                            }
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      FlatButton(
                          color: Colors.green,
                          onPressed: () async {
                            if (appGet.stkCountController.value.text ==
                                qty.toString()) {
                              await ApiServer.instance.getSubDetailsProduct(
                                  list[0]["id"],
                                  appGet.listDetailsOrders[0]['id'].toString());
                              await ApiServer.instance.getSubDetailProductsOut(
                                  list[0]["id"],
                                  appGet.listDetailsOrders[0]['id'].toString());

                              Future.delayed(Duration(milliseconds: 500), () {
                                Get.to(() => KelloList(
                                    list: list,
                                    idDetail: list[0]["id"],
                                    idOrder: appGet.listDetailsOrders[0]["id"],
                                    idProduct: list[0]["product_id"]));
                              });
                              Navigator.pop(context);
                            } else {
                              setToast("Feil mengde", color: Colors.red);
                            }
                          },
                          child: Text(
                            "pillekontroll",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                    ],
                  )
                ],
              ),
            ));
          } else if (unitId == 1) {
            appGet.barCodeController.value.text = "";
            // await ApiServer.instance.getSubDetailsProduct(
            //     list[0]["id"], appGet.listDetailsOrders[0]['id'].toString());
            // await ApiServer.instance.getSubDetailProductsOut(
            //     list[0]["id"], appGet.listDetailsOrders[0]['id'].toString());

            Future.delayed(Duration(milliseconds: 500), () {
              Get.dialog(AlertDialog(
                title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "$qty",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        // Spacer(),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Container(
                              height: 100,
                              width: 200,
                              child: CustomTextFormField(
                                hintText: "Total Kg",
                                textEditingController: textEditingController,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        FlatButton(
                            color: Colors.green,
                            onPressed: () async {
                              if (appGet.stkCountController.value.text ==
                                  qty.toString()) {
                                await ApiServer.instance
                                    .getUpdateProductBarcode(list[0]["id"]);
                                await ApiServer.instance.getUpdateScanStatus(
                                    list[0]["id"],
                                    appGet.mapStatus["data"][0]["id"]);
                                appGet.save(
                                    qty,
                                    appGet.barCodeController.value.text,
                                    list[0]["id"],
                                    appGet.listDetailsOrders[0]["id"],
                                    selectedProductID,
                                    unitId,
                                    name);

                                appGet.barCodeController.value.text = "";

                                await ApiServer.instance.getDetailsOrders(
                                    appGet.listDetailsOrders[0]["id"]);

                                Navigator.pop(context);
                              } else {
                                setToast("Feil mengde", color: Colors.red);
                              }
                            },
                            child: Text(
                              "Done",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        FlatButton(
                            color: Colors.green,
                            onPressed: () async {
                              if (appGet.stkCountController.value.text ==
                                  qty.toString()) {
                                await ApiServer.instance.getSubDetailsProduct(
                                    list[0]["id"],
                                    appGet.listDetailsOrders[0]['id']
                                        .toString());
                                await ApiServer.instance
                                    .getSubDetailProductsOut(
                                        list[0]["id"],
                                        appGet.listDetailsOrders[0]['id']
                                            .toString());

                                Future.delayed(Duration(milliseconds: 500), () {
                                  Get.to(() => KelloList(
                                      list: list,
                                      idDetail: list[0]["id"],
                                      idOrder: appGet.listDetailsOrders[0]
                                          ["id"],
                                      idProduct: list[0]["product_id"]));
                                });
                                Navigator.pop(context);
                              } else {
                                setToast("Feil mengde", color: Colors.red);
                              }
                            },
                            child: Text(
                              "pillekontroll",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ],
                    )
                  ],
                ),
              ));
            });
          } else if (unitId == 2) {
            Get.dialog(AlertDialog(
              title: Column(
                children: [
                  Text(
                    "$qty",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  FlatButton(
                      color: Colors.green,
                      onPressed: () async {
                        if (appGet.stkCountController.value.text ==
                            qty.toString()) {
                          await ApiServer.instance
                              .getUpdateProductBarcode(list[0]["id"]);
                          await ApiServer.instance.getUpdateScanStatus(
                              list[0]["id"], appGet.mapStatus["data"][0]["id"]);
                          appGet.save(
                              qty,
                              appGet.barCodeController.value.text,
                              list[0]["id"],
                              appGet.listDetailsOrders[0]["id"],
                              selectedProductID,
                              unitId,
                              name);

                          appGet.barCodeController.value.text = "";

                          await ApiServer.instance.getDetailsOrders(
                              appGet.listDetailsOrders[0]["id"]);
                          Navigator.pop(context);

                          // Navigator.pop(context);
                        } else {
                          setToast("Feil mengde", color: Colors.red);
                        }
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ))
                ],
              ),
            ));
          }
        } else {
          await ApiServer.instance
              .getReaderBarcode(appGet.barCodeController.value.text);
          await ApiServer.instance.getUpdateProductBarcode(list[0]["id"]);
          await ApiServer.instance.getUpdateScanStatus(
              list[0]["id"], appGet.mapStatus["data"][0]["id"]);
          appGet.save(
              1,
              appGet.barCodeController.value.text,
              list[0]["id"],
              appGet.listDetailsOrders[0]["id"],
              selectedProductID,
              unitId,
              name);

          await ApiServer.instance
              .getDetailsOrders(appGet.listDetailsOrders[0]["id"]);

          appGet.barCodeController.value.text = "";
          if (check() == 2) {
            Get.back();
          }
        }
      }
    } else {
      if (list2.length != 0) {
        setToast("Item Done", color: Colors.red);
        appGet.barCodeController.value.text = "";
        list2.clear();
      }
    }
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
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 25.h,
                    width: 300.w,
                    child: TextFormField(
                      controller: appGet.barCodeController.value,
                      focusNode: appGet.detailFocus,
                      autofocus: kReleaseMode,
                      decoration: InputDecoration(
                        hintText: "Barcode",
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
                              radius: 10.r,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              )),
                          onPressed: () {
                            appGet.barCodeController.value.text = '';
                            // SystemChannels.textInput.invokeMethod('TextInput.hide');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                InkWell(
                  onTap: () async {
                    await appGet
                        .getPostApi(appGet.barCodeController.value.text);

                    if (appGet.barCodeController.value.text != "") {
                      List list = await appGet.listDetailsOrders[0]
                              ["orderDetails"]
                          .where((element) =>
                              element["is_sacn_barcode"] == 0 &&
                              element["barcode"] == appGet.content01.value)
                          .toList();

                      List list2 = await appGet.listDetailsOrders[0]
                              ["orderDetails"]
                          .where((element) =>
                              element["is_sacn_barcode"] == 1 &&
                              element["barcode"] == appGet.content01.value)
                          .toList();

                      Future.delayed(Duration(milliseconds: 200), () async {
                        if (list.length != 0 || list2.length != 0) {
                          whereProduct(list, list2);
                        } else {
                          setToast(
                              "Denne varen er ikke tilgjengelig på bestilling",
                              color: Colors.red);
                        }
                      });
                    } else {
                      setToast("Enter Barcode", color: Colors.red);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        height: 30.h,
                        width: 280.w,
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
                appGet.listDetailsOrders[0]["orderDetails"].length != 0
                    ? RefreshIndicator(
                        onRefresh: () async {
                          return await ApiServer.instance.getDetailsOrders(
                              appGet.listDetailsOrders[0]['id']);
                        },
                        child: Container(
                          height: Get.height / 1.67.h,
                          child: ListView.separated(
                            separatorBuilder: (_, inde) => SizedBox(height: 1),
                            padding: EdgeInsets.zero,
                            itemCount: appGet
                                .listDetailsOrders[0]["orderDetails"].length,
                            itemBuilder: (context, index2) => InkWell(
                              onTap: () {
                                appGet.listDetailsOrders[0]["orderDetails"]
                                            [index2]["is_sacn_barcode"] ==
                                        1
                                    ? setToast("Varen er sjekket",
                                        color: Colors.red)
                                    : Get.dialog(AlertDialog(
                                        title: Column(children: [
                                          Text(
                                            "Produktmigrasjon",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Wrap(
                                              direction: Axis.vertical,
                                              children: List.generate(
                                                listMap.length,
                                                (indexStatus) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await ApiServer.instance
                                                          .getUpdateProductBarcode(
                                                              appGet.listDetailsOrders[
                                                                          0][
                                                                      "orderDetails"]
                                                                  [
                                                                  index2]['id']);

                                                      await ApiServer.instance
                                                          .getUpdateScanStatus(
                                                              appGet.listDetailsOrders[
                                                                          0][
                                                                      "orderDetails"]
                                                                  [
                                                                  index2]['id'],
                                                              listMap[indexStatus]
                                                                  ["id"]);

                                                      await ApiServer.instance
                                                          .getDetailsOrders(
                                                              appGet.listDetailsOrders[
                                                                  0]["id"]);
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                        width: 100.w,
                                                        height: 20.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.black54,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            listMap[indexStatus]
                                                                ["name"],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 9.sp),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   width: 8,
                                                // ),
                                                // InkWell(
                                                //   onTap: () async {
                                                //     await ApiServer.instance
                                                //         .getUpdateProductBarcode(
                                                //             appGet.listDetailsOrders[
                                                //                         0]
                                                //                     ["orderDetails"]
                                                //                 [index2]['id']);
                                                //     await ApiServer.instance
                                                //         .getUpdateScanStatus(
                                                //             appGet.listDetailsOrders[
                                                //                         0]
                                                //                     ["orderDetails"]
                                                //                 [index2]['id'],
                                                //             appGet.mapStatus["data"]
                                                //                 [2]["id"]);
                                                //     ApiServer.instance
                                                //         .getDetailsOrders(appGet
                                                //                 .listDetailsOrders[
                                                //             0]["id"]);
                                                //     setState(() {});
                                                //     Get.back();
                                                //   },
                                                //   child: Container(
                                                //       decoration: BoxDecoration(
                                                //         borderRadius:
                                                //             BorderRadius.circular(
                                                //                 5),
                                                //         color: Colors.black54,
                                                //       ),
                                                //       child: Padding(
                                                //         padding: const EdgeInsets
                                                //                 .symmetric(
                                                //             horizontal: 6,
                                                //             vertical: 8),
                                                //         child: Text(
                                                //           appGet.mapStatus["data"]
                                                //               [2]["name"],
                                                //           style: TextStyle(
                                                //               color: Colors.white,
                                                //               fontSize: 9.sp),
                                                //         ),
                                                //       )),
                                                // ),
                                              ))
                                        ]),
                                      ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: appGet.listDetailsOrders[0]
                                                    ["orderDetails"][index2]
                                                ['is_sacn_barcode'] ==
                                            1
                                        ? appGet.listDetailsOrders[0]
                                                        ["orderDetails"][index2]
                                                    ['scan_status'] !=
                                                1
                                            ? Colors.grey
                                            : AppColors.doneColor
                                        : AppColors.newColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${appGet.listDetailsOrders[0]["orderDetails"][index2]['qty']}" +
                                                  " X" ??
                                              "",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            decoration: appGet.listDetailsOrders[
                                                                    0]
                                                                ["orderDetails"]
                                                            [index2]
                                                        ['is_sacn_barcode'] ==
                                                    1
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${appGet.listDetailsOrders[0]["orderDetails"][index2]['product_name']}" ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              decoration: appGet.listDetailsOrders[
                                                                      0][
                                                                  "orderDetails"]
                                                              [index2]
                                                          ['is_sacn_barcode'] ==
                                                      1
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "${appGet.listDetailsOrders[0]["orderDetails"][index2]['sum_kg'] == "0" ? "" : appGet.listDetailsOrders[0]["orderDetails"][index2]['sum_kg'] ?? ""}",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffA9AAAA),
                                            decoration: appGet.listDetailsOrders[
                                                                    0]
                                                                ["orderDetails"]
                                                            [index2]
                                                        ['is_sacn_barcode'] ==
                                                    1
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "${appGet.listDetailsOrders[0]["orderDetails"][index2]['unit_name']}",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffA9AAAA),
                                            decoration: appGet.listDetailsOrders[
                                                                    0]
                                                                ["orderDetails"]
                                                            [index2]
                                                        ['is_sacn_barcode'] ==
                                                    1
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                      ],
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
                            "No Itmes",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
                SizedBox(height: 2.h),
                FlatButton(
                    onPressed: appGet.listDetailsOrders[0]["orderDetails"]
                                .where((element) =>
                                    element["is_sacn_barcode"] == 1)
                                .toList()
                                .length !=
                            appGet.listDetailsOrders[0]["orderDetails"].length
                        ? null
                        : () async {
                            await ApiServer.instance.getUpdateOrders(
                                appGet.listDetailsOrders[0]["id"]);
                            setToast("Done");
                            Get.back();
                          },
                    child: Container(
                      height: 30.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appGet.listDetailsOrders[0]["orderDetails"]
                                      .where((element) =>
                                          element["is_sacn_barcode"] == 1)
                                      .toList()
                                      .length !=
                                  appGet.listDetailsOrders[0]["orderDetails"]
                                      .length
                              ? Colors.grey
                              : Colors.green),
                      child: Center(
                          child: Text(
                        "Ferdig",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    )),
                SizedBox(height: 4.h),
              ],
            ));
          }),
        ));
  }
}
