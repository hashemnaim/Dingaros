import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/model/order_delailt.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/customTextField.dart';
import 'package:dinengros/view/widget/custom_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddKelloList extends StatefulWidget {
  final int idOrder, idDetail, idProduct, index;
  final OrderDetails orderDetails;
  AddKelloList(
      {Key key,
      this.orderDetails,
      this.idOrder,
      this.idDetail,
      this.idProduct,
      this.index})
      : super(key: key);
  @override
  _DetailsOrdersListState createState() => _DetailsOrdersListState();
}

class _DetailsOrdersListState extends State<AddKelloList> {
  AppController appGet = Get.find();

  double total = 0.0;
  TextEditingController kelloController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  List<double> listWeight;
  // List listInScreen = [];
  setListWeight() {
    if (appGet
            .listDetailsOrders2.value.orderDetails[widget.index].list.length !=
        0) {
      total = appGet.listDetailsOrders2.value.orderDetails[widget.index].list
          .map((e) => double.parse(e.weight))
          .toList()
          .reduce((i, j) => i + j);
      setState(() {
        Future.delayed(Duration(milliseconds: 1)).then(
            (value) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
      });
    }
  }

  @override
  void initState() {
    setListWeight();

    super.initState();
  }

  outOrder(String kello, int qty) async {
    await ApiServer.instance.outputOrder(
        orderDetailId: widget.orderDetails.id,
        orderId: widget.idOrder,
        productId: widget.orderDetails.productId,
        unitId: widget.orderDetails.unitId,
        barcode: appGet.content01.value,
        pdate: appGet.content13.value,
        barcodeAfter: appGet.kelloController.value.text,
        exdate: appGet.content17.value,
        batchNum: appGet.content10.value,
        productName: widget.orderDetails.productName,
        qty: qty,
        moveType: "output",
        kilo: kello ?? "",
        stkcount: appGet.content37.value ?? "");

    await ApiServer.instance.getUpdateScanStatus(widget.orderDetails.id, 1);

    ApiServer.instance.getDetailsOrders(widget.idOrder);

    setListWeight();

    if (appGet
            .listDetailsOrders2.value.orderDetails[widget.index].list.length ==
        widget.orderDetails.qty) {
      await ApiServer.instance.getUpdateProductBarcode(widget.orderDetails.id);
      setToast("Done");
      appGet.kelloFocus.requestFocus();
      appGet.detailFocus.requestFocus();

      Future.delayed(Duration(milliseconds: 10)).then(
          (value) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
      Get.back();
    } else {
      appGet.kelloFocus.requestFocus();
      // appGet.detailFocus.requestFocus();

      Future.delayed(Duration(milliseconds: 10)).then(
          (value) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
      setToast("Saved");
    }
  }

  @override
  Widget build(BuildContext context) {
    // appGet.barCodeFocus.unfocus();

    return Background(
      back: true,
      notfi: true,
      botton: Obx(() {
        print(appGet.text.value);
        return appGet.listDetailsOrders2.value.orderDetails[widget.index].list
                    .length ==
                0
            ? Container()
            : FlatButton(
                onPressed: appGet.listDetailsOrders2.value
                            .orderDetails[widget.index].list.length ==
                        widget.orderDetails.qty
                    ? () async {
                        await ApiServer.instance
                            .getUpdateProductBarcode(widget.orderDetails.id);

                        await ApiServer.instance
                            .getUpdateScanStatus(widget.orderDetails.id, 1);
                        ApiServer.instance.getDetailsOrders(widget.idOrder);
                        appGet.detailFocus.requestFocus();
                        appGet.kelloFocus.requestFocus();
                        Future.delayed(Duration(milliseconds: 100)).then(
                            (value) => SystemChannels.textInput
                                .invokeMethod('TextInput.hide'));
                        appGet.barCodeController.value.text = "";
                        setToast("Done");
                        Get.back();
                      }
                    : null,
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: appGet.listDetailsOrders2.value
                                  .orderDetails[widget.index].list.length ==
                              widget.orderDetails.qty
                          ? Colors.green
                          : Colors.grey),
                  child: Center(
                      child: Text(
                    "Ferdig",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ));
      }),
      contant: Obx(() {
        print(appGet.text.value);
        print(widget.index);

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // widget.orderDetails.unitId == 1
            //     ?
            appGet.listDetailsOrders2.value.orderDetails[widget.index].list
                        .length ==
                    0
                ? CustomText("0.0")
                : Center(
                    child: Text(
                      appGet.listDetailsOrders2.value.orderDetails[widget.index]
                                  .list
                                  .map((e) => double.parse(e.weight))
                                  .toList()
                                  .reduce((i, j) => i + j)
                                  .toString()
                                  .length >
                              4
                          ? appGet.listDetailsOrders2.value
                                  .orderDetails[widget.index].list
                                  .map((e) => double.parse(e.weight))
                                  .toList()
                                  .reduce((i, j) => i + j)
                                  .toString()
                                  .substring(0, 4) +
                              " KG"
                          : appGet.listDetailsOrders2.value
                                  .orderDetails[widget.index].list
                                  .map((e) => double.parse(e.weight))
                                  .toList()
                                  .reduce((i, j) => i + j)
                                  .toString() +
                              " KG",
                      style: GoogleFonts.montserrat(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffA9AAAA)),
                    ),
                  ),
            // : Container(),
            Container(
                width: Get.width,
                child: Center(
                    child: Text(
                  widget.orderDetails.qty.toString() +
                      " X " +
                      widget.orderDetails.productName,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ))),
            SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: appGet.kelloController.value,
                autofocus: true,
                focusNode: appGet.kelloFocus,
                onFieldSubmitted: (v) async {
                  await appGet.getPostApi(appGet.kelloController.value.text);

                  if (widget.orderDetails.barcode
                      .contains(appGet.content01.value)) {
                    if (appGet.listDetailsOrders2.value
                            .orderDetails[widget.index].list.length ==
                        widget.orderDetails.qty) {
                      setToast("Done All Product", color: Colors.red);
                    } else {
                      if (appGet.content310.value == "") {
                        Future.delayed(Duration(milliseconds: 100), () async {
                          addwidth("", 0);
                        });
                      } else {
                        outOrder(appGet.content310.value, 1);
                      }
                    }
                  }

                  // setState(() {
                  //   Future.delayed(Duration(milliseconds: 1)).then((value) =>
                  //       SystemChannels.textInput
                  //           .invokeMethod('TextInput.hide'));
                  // });
                  appGet.kelloController.value.text = "";
                },
                decoration: InputDecoration(
                  hintText: "Barcode",
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
                      appGet.kelloController.value.text = "";
                    },
                  ),
                ),
              ),
            ),

            Expanded(
              child: Obx(
                () => appGet.listDetailsOrders2.value.orderDetails[widget.index]
                            .list.length !=
                        0
                    ? Container(
                        // height: Get.height / 1.4.h,
                        child: ListView.separated(
                            separatorBuilder: (_, index) => SizedBox(height: 2),
                            itemCount: appGet.listDetailsOrders2.value
                                .orderDetails[widget.index].list.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () => {
                                    Future.delayed(Duration(milliseconds: 100),
                                        () {
                                      addwidth(
                                          appGet
                                              .listDetailsOrders2
                                              .value
                                              .orderDetails[widget.index]
                                              .list[index]
                                              .weight,
                                          1);
                                    })
                                  },
                                  child: Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: AppColors.doneColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "  " +
                                                  widget.orderDetails
                                                      .productName ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                appGet
                                                            .listDetailsOrders2
                                                            .value
                                                            .orderDetails[
                                                                widget.index]
                                                            .list[index]
                                                            .batchNum ==
                                                        null
                                                    ? ""
                                                    : "Batch / S.N" +
                                                        appGet
                                                            .listDetailsOrders2
                                                            .value
                                                            .orderDetails[
                                                                widget.index]
                                                            .list[index]
                                                            .batchNum,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),

                                              //   Text(
                                              //   "Vekt " +
                                              //       appGet
                                              //           .listDetailsOrders2
                                              //           .value
                                              //           .orderDetails[
                                              //               widget.index]
                                              //           .list[index]
                                              //           .weight
                                              //           .toString(),
                                              //   style: TextStyle(
                                              //       fontSize: 14,
                                              //       color: Colors.black),
                                              // ),
                                              Spacer(),

                                              Text(
                                                "Vekt " +
                                                    appGet
                                                        .listDetailsOrders2
                                                        .value
                                                        .orderDetails[
                                                            widget.index]
                                                        .list[index]
                                                        .weight
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
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
                              );
                            }),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.orderDetails.qty} elementer må legges inn",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }

  addwidth(String weight, int update) => Get.dialog(AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                      width: 60,
                      // height: 30,
                      child: CustomText(
                        "Vekt",
                        fontSize: 16,
                      )),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Container(
                    child: CustomTextFormField(
                        textEditingController: kelloController..text = weight,
                        textInputType: TextInputType.number),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FlatButton(
                      color: Colors.red,
                      onPressed: () async {
                        appGet.kelloFocus.requestFocus();
                        Future.delayed(Duration(milliseconds: 10)).then(
                            (value) => SystemChannels.textInput
                                .invokeMethod('TextInput.hide'));
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FlatButton(
                      color: Colors.green,
                      onPressed: () async {
                        if (kelloController.text == "") {
                          setToast("Enter Weigth", color: Colors.red);
                        }
                        if (update == 0) {
                          outOrder(kelloController.text, 1);
                          appGet.kelloFocus.requestFocus();
                          Future.delayed(Duration(milliseconds: 10)).then(
                              (value) => SystemChannels.textInput
                                  .invokeMethod('TextInput.hide'));
                          Navigator.pop(context);
                        } else {
                          await ApiServer.instance.getUpdateWidth(
                            widget.idOrder,
                            widget.orderDetails.id,
                            widget.orderDetails.productId,
                            kelloController.text,
                          );
                          ApiServer.instance.getDetailsOrders(widget.idOrder);

                          setListWeight();
                          appGet.kelloFocus.requestFocus();
                          Future.delayed(Duration(milliseconds: 1)).then(
                              (value) => SystemChannels.textInput
                                  .invokeMethod('TextInput.hide'));
                          setState(() {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      )

                      //  Text(
                      //   "pillekontroll",
                      //   style: TextStyle(color: Colors.white, fontSize: 18),
                      // )
                      ),
                ),
              ],
            )
          ],
        ),
      ));

  Widget killoAlert() {
    return AlertDialog(
      title: StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              CustomText(
                "Vil du legge til samme vekt",
                fontSize: 16,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      appGet.kelloController.value.text = "";
                      appGet.kelloFocus.requestFocus();
                      Future.delayed(Duration(milliseconds: 1)).then((value) =>
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide'));
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: CustomText(
                        "cancel",
                        color: Colors.white,
                        fontSize: 18,
                      )),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      outOrder(appGet.kelloController.value.text, 1);
                    },
                    child: Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                          color: AppColors.primary2,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: CustomText(
                        "OK",
                        color: Colors.white,
                        fontSize: 18,
                      )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
