import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/model/order_delailt.dart';
import 'package:dinengros/value/animate_do.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/customTextField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'add_batch_lot.dart';
import 'add_kello_screen.dart';

class DetailsOrdersList extends StatefulWidget {
  final int idOrder, statusId;
  const DetailsOrdersList({
    Key key,
    this.idOrder,
    this.statusId,
  }) : super(key: key);
  @override
  _DetailsOrdersListState createState() => _DetailsOrdersListState();
}

class _DetailsOrdersListState extends State<DetailsOrdersList> {
  AppController appGet = Get.find();
  int index;
  // int selectedProductID;
  ScrollController scrollController = ScrollController();
  String batch;
  bool atuofoucd = true;
  List listselect = [];
  TextEditingController totalkgController = TextEditingController();
  @override
  void initState() {
    stautsList();
    super.initState();
  }

  check() {
    List list = appGet.listDetailsOrders.value.orderDetails
        .where((element) => element.isSacnBarcode == 0)
        .toList();

    int x = list.length == 0
        ? 0
        : list.length != appGet.listDetailsOrders.value.orderDetails.length
            ? 1
            : 2;
    return x;
  }

  List listMap = [];
  var dialog;

  stautsList() {
    setState(() {
      Future.delayed(Duration(milliseconds: 1)).then(
          (value) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
    });
  }

  goBatchLot(OrderDetails orderDetails, int index2, int idStatus) async {
    Get.back();

    Get.off(() => BatchLotScreen(
          statusId: idStatus,
          orderDetails: orderDetails,
          index: index2,
        ));
  }

  double setListWeight(List<ListOrderDetailsOut> list) {
    if (list.length != 0) {
      List<double> listWeight =
          list.map((e) => double.parse(e.weight)).toList();
      double total = listWeight.reduce((i, j) => i + j);
      return total;
    } else {
      return 0.0;
    }
  }

  goToKelo(OrderDetails orderDetails) async {
    Future.delayed(Duration(milliseconds: 10), () {
      Navigator.pop(context);

      int index =
          appGet.listDetailsOrders2.value.orderDetails.indexOf(orderDetails);
      appGet.barCodeController.value.text = "";

      Get.to(() => AddKelloList(
          orderDetails: orderDetails,
          idDetail: orderDetails.id,
          idOrder: widget.idOrder,
          index: index,
          idProduct: orderDetails.productId));
    });
  }

  getKelo(OrderDetails orderDetails) {
    Future.delayed(Duration(milliseconds: 100), () {
      dialog = Get.dialog(AlertDialog(
        title: Column(
          children: [
            Text(
              orderDetails.productName,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Antall  ${orderDetails.qty}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Total Kg",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      height: 100,
                      // width: 200,
                      child: CustomTextFormField(
                        hintText: "Total Kg",
                        textEditingController: totalkgController
                          ..text = appGet.content310.value ?? "",
                        textInputType: TextInputType.number,
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: 4,),
              ],
            ),
            Text(
              setListWeight(orderDetails.list) == 0.0
                  ? ""
                  : "Totalt ut fra lager " +
                      setListWeight(orderDetails.list).toString() +
                      " Kg",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              children: [
                orderDetails.qty == 1
                    ? Container()
                    : Expanded(
                        child: FlatButton(
                            color: Colors.green,
                            onPressed: () async {
                              goToKelo(orderDetails);
                            },
                            child: Text(
                              "Stk",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                      ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: FlatButton(
                      color: Colors.green,
                      onPressed: () async {
                        if (orderDetails.qty == orderDetails.list.length) {
                          await ApiServer.instance
                              .getUpdateProductBarcode(orderDetails.id);

                          appGet.barCodeController.value.text = "";

                          ApiServer.instance.getDetailsOrders(widget.idOrder);
                          appGet.detailFocus.requestFocus();

                          Future.delayed(Duration(milliseconds: 1)).then(
                              (value) => SystemChannels.textInput
                                  .invokeMethod('TextInput.hide'));
                          Get.back();
                        } else {
                          appGet.outputOrder(orderDetails,
                              totalkgController.text, 1, widget.idOrder);
                        }
                      },
                      child: Text(
                        "Total Kg",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              ],
            )
          ],
        ),
      ));
    });
    if (dialog == null) {
      appGet.detailFocus.requestFocus();

      Future.delayed(Duration(milliseconds: 1)).then(
          (value) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
    }
  }

  getEsk(OrderDetails orderDetails) {
    dialog = Get.dialog(AlertDialog(
      title: Column(
        children: [
          Text(
            orderDetails.productName,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "Antall  ${orderDetails.qty}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                    color: Colors.green,
                    onPressed: () async {
                      int index = appGet.listDetailsOrders2.value.orderDetails
                          .indexOf(orderDetails);
                      print(index);
                      goBatchLot(orderDetails, index, 1);
                    },
                    child: Text(
                      "Batch/Lot",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: FlatButton(
                    color: Colors.green,
                    onPressed: () async {
                      appGet.outputOrder(
                          orderDetails,
                          appGet.content310.value.toString(),
                          1,
                          widget.idOrder);
                    },
                    child: Text(
                      "Ferdig",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
              ),
            ],
          )
        ],
      ),
    ));

    if (dialog == null) {
      appGet.detailFocus.requestFocus();

      Future.delayed(Duration(milliseconds: 1)).then(
          (value) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
    }
  }

  whereProduct(OrderDetails orderDetails) async {
    if (orderDetails.unitId == 1) {
      totalkgController.text = "";
      getKelo(orderDetails);
    } else if (orderDetails.unitId == 2) {
      getEsk(orderDetails);
    } else if (orderDetails.unitId == 3) {
      getEsk(orderDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Background(
          back: true,
          notfi: true,
          bottonbool: appGet.listDetailsOrders.value.orderDetails == null,
          botton: appGet.listDetailsOrders.value.orderDetails == null
              ? Container()
              : FlatButton(
                  onPressed: appGet.listDetailsOrders.value.orderDetails
                              .where((element) => element.isSacnBarcode == 1)
                              .toList()
                              .length !=
                          appGet.listDetailsOrders.value.orderDetails.length
                      ? null
                      : () async {
                          await ApiServer.instance.getUpdateOrders(
                              appGet.listDetailsOrders.value.id);
                          setToast("Ferdig");
                          Get.back();
                        },
                  child: Container(
                    height: 30.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: appGet.listDetailsOrders.value.orderDetails
                                    .where(
                                        (element) => element.isSacnBarcode == 1)
                                    .toList()
                                    .length !=
                                appGet
                                    .listDetailsOrders.value.orderDetails.length
                            ? Colors.grey
                            : Colors.green),
                    child: Center(
                        child: Text(
                      "Ferdig",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  )),
          contant: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  height: 25.h,
                  width: 300.w,
                  child: TextFormField(
                    controller: appGet.barCodeController.value,
                    focusNode: appGet.detailFocus,
                    autofocus: atuofoucd,
                    // onTap: () {
                    //   SystemChannels.textInput.invokeMethod('TextInput.hide');
                    // },
                    onFieldSubmitted: (v) async {
                      await appGet
                          .getPostApi(appGet.barCodeController.value.text);

                      if (appGet.barCodeController.value.text != "") {
                        if (appGet.listDetailsOrders.value.orderDetails
                                .where((element) =>
                                    element.isSacnBarcode == 0 &&
                                    element.barcode
                                        .contains(appGet.content01.value))
                                .toList()
                                .length !=
                            0) {
                          OrderDetails orderDetails = appGet
                              .listDetailsOrders2.value.orderDetails
                              .firstWhere((element) =>
                                  element.isSacnBarcode == 0 &&
                                  element.barcode
                                      .contains(appGet.content01.value));
                          print(orderDetails);
                          whereProduct(orderDetails);
                        } else {
                          if (appGet.listDetailsOrders.value.orderDetails
                                  .where((element) =>
                                      element.isSacnBarcode == 1 &&
                                      element.barcode
                                          .contains(appGet.content01.value))
                                  .toList()
                                  .length !=
                              0) {
                            appGet.barCodeController.value.text = "";

                            setToast("Product done", color: Colors.red);
                            appGet.detailFocus.requestFocus();

                            Future.delayed(Duration(milliseconds: 1)).then(
                                (value) => SystemChannels.textInput
                                    .invokeMethod('TextInput.hide'));
                          } else {
                            setToast(
                                "Denne varen er ikke tilgjengelig på bestilling",
                                color: Colors.red);
                            appGet.barCodeController.value.text = "";
                            appGet.detailFocus.requestFocus();

                            Future.delayed(Duration(milliseconds: 1)).then(
                                (value) => SystemChannels.textInput
                                    .invokeMethod('TextInput.hide'));
                          }
                        }
                        // });
                      } else {
                        setToast("Enter Barcode", color: Colors.red);
                      }
                    },
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
                          setState(() {
                            Future.delayed(Duration(milliseconds: 1)).then(
                                (value) => SystemChannels.textInput
                                    .invokeMethod('TextInput.hide'));
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Obx(
                () => appGet.listDetailsOrders.value.orderDetails == null
                    ? Container(
                        height: Get.height / 1.6,
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...List.generate(
                                  5,
                                  (indexStatus) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 70,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.4)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              height: 10,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.4))),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              height: 10,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.4)))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                        ))
                    : appGet.listDetailsOrders.value.orderDetails.length != 0
                        ? RefreshIndicator(
                            onRefresh: () async {
                              return await ApiServer.instance
                                  .getDetailsOrders(widget.idOrder);
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: Get.height / 1.6,
                                  child: ListView.separated(
                                      primary: false,
                                      shrinkWrap: true,
                                      separatorBuilder: (_, inde) =>
                                          SizedBox(height: 1),
                                      padding: EdgeInsets.zero,
                                      itemCount: appGet.listDetailsOrders.value
                                          .orderDetails.length,
                                      itemBuilder: (context, index2) {
                                        appGet.listDetailsOrders.value
                                            .orderDetails
                                            .sort((a, b) => a.isSacnBarcode
                                                .compareTo(b.isSacnBarcode));

                                        return InkWell(
                                          onTap: () {
                                            appGet
                                                        .listDetailsOrders
                                                        .value
                                                        .orderDetails[index2]
                                                        .isSacnBarcode ==
                                                    1
                                                ? setToast("Varen er sjekket",
                                                    color: Colors.red)
                                                : Get.dialog(AlertDialog(
                                                    title: Column(children: [
                                                      Text(
                                                        "Alternativer",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      SizedBox(
                                                        height: 15.h,
                                                      ),
                                                      Wrap(
                                                          direction:
                                                              Axis.vertical,
                                                          children:
                                                              List.generate(
                                                            appGet
                                                                    .statusModel
                                                                    .value
                                                                    .data
                                                                    .length -
                                                                1,
                                                            (indexStatus) =>
                                                                Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  if (appGet
                                                                          .statusModel
                                                                          .value
                                                                          .data[indexStatus +
                                                                              1]
                                                                          .id ==
                                                                      2) {
                                                                    await ApiServer
                                                                        .instance
                                                                        .getUpdateProductBarcode(appGet
                                                                            .listDetailsOrders
                                                                            .value
                                                                            .orderDetails[index2]
                                                                            .id);

                                                                    await ApiServer.instance.getUpdateScanStatus(
                                                                        appGet
                                                                            .listDetailsOrders
                                                                            .value
                                                                            .orderDetails[
                                                                                index2]
                                                                            .id,
                                                                        appGet
                                                                            .statusModel
                                                                            .value
                                                                            .data[indexStatus +
                                                                                1]
                                                                            .id);

                                                                    appGet
                                                                        .barCodeController
                                                                        .value
                                                                        .text = "";

                                                                    ApiServer
                                                                        .instance
                                                                        .getDetailsOrders(
                                                                            widget.idOrder);
                                                                    appGet
                                                                        .detailFocus
                                                                        .requestFocus();

                                                                    Future.delayed(Duration(
                                                                            milliseconds:
                                                                                1))
                                                                        .then((value) => SystemChannels
                                                                            .textInput
                                                                            .invokeMethod('TextInput.hide'));
                                                                    Get.back();
                                                                  } else {
                                                                    if (appGet
                                                                            .listDetailsOrders
                                                                            .value
                                                                            .orderDetails[index2]
                                                                            .unitId ==
                                                                        1) {
                                                                      int index = appGet
                                                                          .listDetailsOrders2
                                                                          .value
                                                                          .orderDetails
                                                                          .indexWhere((element) =>
                                                                              element.productId ==
                                                                              appGet.listDetailsOrders.value.orderDetails[index2].productId);
                                                                      print(
                                                                          index);
                                                                      goBatchLot(
                                                                          appGet.listDetailsOrders.value.orderDetails[
                                                                              index2],
                                                                          index,
                                                                          appGet
                                                                              .statusModel
                                                                              .value
                                                                              .data[indexStatus + 1]
                                                                              .id);
                                                                    } else {
                                                                      appGet.outputOrder(
                                                                          appGet.listDetailsOrders.value.orderDetails[
                                                                              index2],
                                                                          appGet
                                                                              .content310
                                                                              .value
                                                                              .toString(),
                                                                          appGet
                                                                              .statusModel
                                                                              .value
                                                                              .data[indexStatus +
                                                                                  1]
                                                                              .id,
                                                                          widget
                                                                              .idOrder);
                                                                    }
                                                                  }
                                                                },
                                                                child: Container(
                                                                    width: 100.w,
                                                                    height: 20.h,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                    child: Center(
                                                                      child:
                                                                          Text(
                                                                        appGet
                                                                            .statusModel
                                                                            .value
                                                                            .data[indexStatus +
                                                                                1]
                                                                            .name,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 9.sp),
                                                                      ),
                                                                    )),
                                                              ),
                                                            ),
                                                          ))
                                                    ]),
                                                  ));
                                          },
                                          child: FadeInLeft(
                                            duration: Duration(
                                                milliseconds: 100 * index2),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: appGet
                                                              .listDetailsOrders
                                                              .value
                                                              .orderDetails[
                                                                  index2]
                                                              .isSacnBarcode ==
                                                          1
                                                      ? AppColors.doneColor
                                                      : appGet
                                                                  .listDetailsOrders
                                                                  .value
                                                                  .orderDetails[
                                                                      index2]
                                                                  .list
                                                                  .length ==
                                                              0
                                                          ? AppColors.newColor
                                                          : Colors.grey[400],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(4),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${appGet.listDetailsOrders.value.orderDetails[index2].qty}" +
                                                                " X" ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          decoration: appGet
                                                                      .listDetailsOrders
                                                                      .value
                                                                      .orderDetails[
                                                                          index2]
                                                                      .isSacnBarcode ==
                                                                  1
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "${appGet.listDetailsOrders.value.orderDetails[index2].productName}" ??
                                                              "",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            decoration: appGet
                                                                        .listDetailsOrders
                                                                        .value
                                                                        .orderDetails[
                                                                            index2]
                                                                        .isSacnBarcode ==
                                                                    1
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : null,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      appGet
                                                                  .listDetailsOrders
                                                                  .value
                                                                  .orderDetails[
                                                                      index2]
                                                                  .unitId ==
                                                              1
                                                          ? Text(
                                                              setListWeight(appGet
                                                                          .listDetailsOrders
                                                                          .value
                                                                          .orderDetails[
                                                                              index2]
                                                                          .list) ==
                                                                      0.0
                                                                  ? ""
                                                                  : setListWeight(appGet
                                                                          .listDetailsOrders
                                                                          .value
                                                                          .orderDetails[
                                                                              index2]
                                                                          .list)
                                                                      .toString(),
                                                              style: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: appGet
                                                                            .listDetailsOrders
                                                                            .value
                                                                            .orderDetails[
                                                                                index2]
                                                                            .list
                                                                            .length ==
                                                                        0
                                                                    ? Color(
                                                                        0xffA9AAAA)
                                                                    : Colors.grey[
                                                                        600],
                                                                decoration: appGet
                                                                            .listDetailsOrders
                                                                            .value
                                                                            .orderDetails[
                                                                                index2]
                                                                            .isSacnBarcode ==
                                                                        1
                                                                    ? TextDecoration
                                                                        .lineThrough
                                                                    : null,
                                                              ),
                                                            )
                                                          : Container(),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "${appGet.listDetailsOrders.value.orderDetails[index2].unitName}",
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: appGet
                                                                      .listDetailsOrders
                                                                      .value
                                                                      .orderDetails[
                                                                          index2]
                                                                      .list
                                                                      .length ==
                                                                  0
                                                              ? Color(
                                                                  0xffA9AAAA)
                                                              : Colors
                                                                  .grey[600],
                                                          decoration: appGet
                                                                      .listDetailsOrders
                                                                      .value
                                                                      .orderDetails[
                                                                          index2]
                                                                      .isSacnBarcode ==
                                                                  1
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                //  SizedBox(height: 24.h),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "No Product",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
              )
            ],
          ),
        ));
  }
}
