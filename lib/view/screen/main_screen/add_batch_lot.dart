import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/model/order_delailt.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/widget/custom_button.dart';
import 'package:dinengros/view/widget/custom_image.dart';
import 'package:dinengros/view/widget/custom_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_orders_screen.dart';

enum SingingCharacter { Stk, Kg, Eske }

class BatchLotScreen extends StatefulWidget {
  final int statusId, index;
  OrderDetails orderDetails;
  BatchLotScreen({
    Key key,
    this.orderDetails,
    this.statusId,
    this.index,
  }) : super(key: key);
  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<BatchLotScreen> {
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

  TextEditingController nameProductController = TextEditingController();

  TextEditingController temperaturController = TextEditingController();
  TextEditingController eftaController = TextEditingController();
  TextEditingController weigthController = TextEditingController();
  // TextEditingController qtyController;

  textClear() {
    appGet.productList.clear();
    appGet.type.value = "";
    eftaController.text = "";
    weigthController.text = "";
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  SingingCharacter character = SingingCharacter.Stk;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: AppColors.primary2,
          leading: GestureDetector(
            onTap: () {
              Get.off(() => DetailsOrdersList(
                    statusId: widget.statusId,
                    idOrder: appGet.listDetailsOrders2.value.id,
                  ));
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Container(
            // height: 400,
            child: SingleChildScrollView(
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    widget.orderDetails.unitId == 1
                        ? Obx(
                            () => appGet
                                        .listDetailsOrders2
                                        .value
                                        .orderDetails[widget.index]
                                        .list
                                        .length ==
                                    0
                                ? Container()
                                : Column(
                                    children: [
                                      Text(
                                        appGet
                                            .listDetailsOrders2
                                            .value
                                            .orderDetails[widget.index]
                                            .list
                                            .length
                                            .toString(),
                                        style: GoogleFonts.montserrat(
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffA9AAAA)),
                                      ),
                                      Center(
                                        child: Text(
                                          setListWeight(appGet
                                                      .listDetailsOrders2
                                                      .value
                                                      .orderDetails[
                                                          widget.index]
                                                      .list) ==
                                                  0.0
                                              ? "0.0"
                                              : setListWeight(appGet
                                                          .listDetailsOrders2
                                                          .value
                                                          .orderDetails[
                                                              widget.index]
                                                          .list)
                                                      .toString() +
                                                  " Kg",
                                          // appGet.listDetailsOrders2.value.orderDetails[widget.index].list
                                          //             .map((e) => double.parse(
                                          //                 e.weight))
                                          //             .toList()
                                          //             .reduce(
                                          //                 (i, j) => i + j)
                                          //             .toString()
                                          //             .length >
                                          //         4
                                          //     ? appGet.listDetailsOrders2.value.orderDetails[widget.index].list
                                          //             .map((e) => double.parse(
                                          //                 e.weight))
                                          //             .toList()
                                          //             .reduce(
                                          //                 (i, j) => i + j)
                                          //             .toString()
                                          //             .substring(0, 4) +
                                          //         " KG"
                                          //     : appGet
                                          //             .listDetailsOrders2
                                          //             .value
                                          //             .orderDetails[widget.index]
                                          //             .list
                                          //             .map((e) => double.parse(e.weight))
                                          //             .toList()
                                          //             .reduce((i, j) => i + j)
                                          //             .toString() +
                                          //         " KG",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffA9AAAA)),
                                        ),
                                      ),
                                    ],
                                  ),
                          )
                        : Container(),
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
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text("Name" + " : ",
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
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: nameProductController
                                ..text = widget.orderDetails.productName,
                              focusNode: focusbatch,
                              enabled: false,
                              minLines: 1,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: "name ",
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
                          child: Text("Batch No" + " : ",
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
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: appGet.batheController.value,
                              autofocus: true,
                              focusNode: focusbatch,
                              maxLines: null,
                              minLines: 1,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: "Batch No",
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
                          child: Text("ExpDate" + " : ",
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
                            child: InkWell(
                              // initialValue: "",
                              onTap: () {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');

                                Get.defaultDialog(
                                    title: "Year",
                                    middleText: "",
                                    content: SingleChildScrollView(
                                      child: Wrap(
                                        children: List.generate(
                                            listYear.length,
                                            (index) => InkWell(
                                                  onTap: () {
                                                    SystemChannels.textInput
                                                        .invokeMethod(
                                                            'TextInput.hide');

                                                    appGet
                                                        .expDateController
                                                        .value
                                                        .text = listYear[index];
                                                    Get.back();
                                                    Get.defaultDialog(
                                                        title: "Month",
                                                        middleText: "",
                                                        content: Wrap(
                                                          children:
                                                              List.generate(
                                                                  listMonth
                                                                      .length,
                                                                  (index) =>
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Get.back();
                                                                          SystemChannels
                                                                              .textInput
                                                                              .invokeMethod('TextInput.hide');

                                                                          appGet
                                                                              .expDateController
                                                                              .value
                                                                              .text = appGet
                                                                                  .expDateController.value.text +
                                                                              "-" +
                                                                              listMonth[index];

                                                                          Get.defaultDialog(
                                                                              title: "Days",
                                                                              middleText: "",
                                                                              content: Wrap(
                                                                                children: List.generate(
                                                                                    listDays.length,
                                                                                    (index) => InkWell(
                                                                                          onTap: () {
                                                                                            SystemChannels.textInput.invokeMethod('TextInput.hide');

                                                                                            appGet.expDateController.value.text = appGet.expDateController.value.text + "-" + listDays[index];
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
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(10.0),
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                        height: 100,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .grey,
                                                                  offset:
                                                                      Offset(
                                                                          1, 2),
                                                                  blurRadius: 8,
                                                                  spreadRadius:
                                                                      4)
                                                            ]),
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
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
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomText(
                                        appGet.expDateController.value.text,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black87,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    widget.orderDetails.unitId != 1
                        ? Container()
                        : Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("Weigth " + " : ",
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
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: weigthController,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: "weigth ",
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
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text("Efta " + " : ",
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
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: eftaController,
                              maxLines: null,
                              minLines: 1,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: "Efta ",
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
                          child: Text("Temperatur " + " : ",
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
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: temperaturController,
                              maxLines: null,
                              minLines: 1,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: "Temperatur ",
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 260,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Obx(() {
                              print(appGet.listDetailsOrders2.value.id);
                              return CustomButton(
                                  text: widget.orderDetails.unitId == 1
                                      ? widget.orderDetails.qty <=
                                              appGet
                                                      .listDetailsOrders2
                                                      .value
                                                      .orderDetails[
                                                          widget.index]
                                                      .list
                                                      .length +
                                                  1
                                          ? "Ferdig"
                                          : "Save"
                                      : "Ferdig",
                                  onTap: () async {
                                    if (appGet.batheController.value.text ==
                                        "") {
                                      setToast("Enter Batch Number");
                                    } else {
                                      if (widget.orderDetails.unitId == 1) {
                                        if (widget.orderDetails.qty <=
                                            appGet
                                                    .listDetailsOrders2
                                                    .value
                                                    .orderDetails[widget.index]
                                                    .list
                                                    .length +
                                                1) {
                                          await ApiServer.instance
                                              .getUpdateProductBarcode(
                                                  widget.orderDetails.id);
                                          await ApiServer.instance.outputOrder(
                                              orderDetailId:
                                                  widget.orderDetails.id,
                                              orderId: appGet
                                                  .listDetailsOrders2.value.id,
                                              productId:
                                                  widget.orderDetails.productId,
                                              unitId:
                                                  widget.orderDetails.unitId,
                                              barcode: appGet.content01.value,
                                              pdate: appGet.content13.value,
                                              barcodeAfter: widget
                                                  .orderDetails.barcodeBefore,
                                              exdate: appGet
                                                  .expDateController.value.text,
                                              batchNum: appGet
                                                  .batheController.value.text,
                                              productName: widget
                                                  .orderDetails.productName,
                                              qty: widget.orderDetails.qty,
                                              moveType: "output",
                                              temperature:
                                                  temperaturController.text,
                                              supplierNum: eftaController.text,
                                              kilo: appGet.content310.value
                                                      .toString() ??
                                                  weigthController.text ??
                                                  "",
                                              stkcount:
                                                  appGet.content37.value ?? "",
                                              scanStatus: widget.statusId);
                                          await ApiServer.instance
                                              .getUpdateScanStatus(
                                                  appGet.listDetailsOrders2
                                                      .value.id,
                                                  widget.statusId);
                                          appGet.barCodeController.value.text =
                                              "";

                                          appGet.detailFocus.requestFocus();
                                          Future.delayed(
                                                  Duration(milliseconds: 1))
                                              .then((value) => SystemChannels
                                                  .textInput
                                                  .invokeMethod(
                                                      'TextInput.hide'));
                                          weigthController.text = "";
                                          setToast("Saved");
                                          ApiServer.instance.getDetailsOrders(
                                              appGet
                                                  .listDetailsOrders2.value.id);
                                          weigthController.text = "";
                                          Get.off(() => DetailsOrdersList(
                                                statusId: widget.statusId,
                                                idOrder: appGet
                                                    .listDetailsOrders2
                                                    .value
                                                    .id,
                                              ));
                                        } else {
                                          if (weigthController.text == "") {
                                            setToast("Enter Weidth");
                                          } else {
                                            await ApiServer.instance.outputOrder(
                                                orderDetailId:
                                                    widget.orderDetails.id,
                                                orderId: appGet
                                                    .listDetailsOrders2
                                                    .value
                                                    .id,
                                                productId: widget
                                                    .orderDetails.productId,
                                                unitId:
                                                    widget.orderDetails.unitId,
                                                barcode: appGet.content01.value,
                                                pdate: appGet.content13.value,
                                                barcodeAfter: widget
                                                    .orderDetails.barcodeBefore,
                                                exdate: appGet.expDateController
                                                    .value.text,
                                                batchNum: appGet
                                                    .batheController.value.text,
                                                productName: widget
                                                    .orderDetails.productName,
                                                qty: widget.orderDetails.qty,
                                                moveType: "output",
                                                temperature:
                                                    temperaturController.text,
                                                supplierNum:
                                                    eftaController.text,
                                                kilo: weigthController.text,
                                                stkcount:
                                                    appGet.content37.value ??
                                                        "",
                                                scanStatus: widget.statusId);
                                            await ApiServer.instance
                                                .getUpdateScanStatus(
                                                    appGet.listDetailsOrders2
                                                        .value.id,
                                                    widget.statusId);
                                            setToast("Saved");
                                            ApiServer.instance.getDetailsOrders(
                                                appGet.listDetailsOrders2.value
                                                    .id);
                                            weigthController.text = "";
                                          }
                                        }
                                      } else {
                                        await ApiServer.instance
                                            .getUpdateProductBarcode(
                                                widget.orderDetails.id);
                                        await ApiServer.instance.outputOrder(
                                            orderDetailId:
                                                widget.orderDetails.id,
                                            orderId: appGet
                                                .listDetailsOrders2.value.id,
                                            productId:
                                                widget.orderDetails.productId,
                                            unitId: widget.orderDetails.unitId,
                                            barcode: appGet.content01.value,
                                            pdate: appGet.content13.value,
                                            barcodeAfter: widget
                                                .orderDetails.barcodeBefore,
                                            exdate: appGet
                                                .expDateController.value.text,
                                            batchNum: appGet
                                                .batheController.value.text,
                                            productName:
                                                widget.orderDetails.productName,
                                            qty: widget.orderDetails.qty,
                                            moveType: "output",
                                            temperature:
                                                temperaturController.text,
                                            supplierNum: eftaController.text,
                                            kilo: appGet.content310.value
                                                    .toString() ??
                                                weigthController.text ??
                                                "",
                                            stkcount:
                                                appGet.content37.value ?? "",
                                            scanStatus: widget.statusId);
                                        await ApiServer.instance
                                            .getUpdateScanStatus(
                                                appGet.listDetailsOrders2.value
                                                    .id,
                                                widget.statusId);
                                        ApiServer.instance.getDetailsOrders(
                                            appGet.listDetailsOrders2.value.id);
                                        weigthController.text = "";
                                        appGet.barCodeController.value.text =
                                            "";

                                        appGet.detailFocus.requestFocus();
                                        Future.delayed(
                                                Duration(milliseconds: 1))
                                            .then((value) => SystemChannels
                                                .textInput
                                                .invokeMethod(
                                                    'TextInput.hide'));
                                        weigthController.text = "";
                                        Get.off(() => DetailsOrdersList(
                                              statusId: widget.statusId,
                                              idOrder: appGet
                                                  .listDetailsOrders2.value.id,
                                            ));
                                      }
                                    }
                                  });
                            }))
                      ],
                    ),
                  ]),
            ),
          ),
          // ),
        ));
    // floatingActionButton: FloatingCustom());
  }
}
