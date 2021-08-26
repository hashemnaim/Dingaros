import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/custom_text.dart';
import 'package:dinengros/view/widget/isload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Controller/getxController/getx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KelloList extends StatefulWidget {
  final int idOrder, idDetail, idProduct;
  final List list;
  const KelloList(
      {Key key, this.list, this.idOrder, this.idDetail, this.idProduct})
      : super(key: key);
  @override
  _DetailsOrdersListState createState() => _DetailsOrdersListState();
}

class _DetailsOrdersListState extends State<KelloList> {
  AppGet appGet = Get.find();
  int qty;
  int unitId;
  String name;
  double total = 0.0;

  List<double> listWeight;
  List listInScreen = [];
  setListWeight() {
    if (appGet.subDetailsOut.length != 0) {
      listWeight =
          appGet.subDetailsOut.map((e) => double.parse(e["weight"])).toList();
      total = listWeight.reduce((i, j) => i + j);
      // setState(() {

      // });
    }
  }

  @override
  void initState() {
    unitId = widget.list[0]["unit_id"];
    qty = widget.list[0]["qty"];
    name = widget.list[0]["product_name"];
    setListWeight();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    appGet.kelloFocus.unfocus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // appGet.barCodeFocus.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        back: true,
        notfi: true,
        contant: Obx(() {
          return SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              unitId == 1
                  ? Center(
                      child: Text(
                        total.toString().length > 4
                            ? total.toString().substring(0, 4) + " KG"
                            : total.toString() + " KG",
                        style: GoogleFonts.montserrat(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffA9AAAA)),
                      ),
                    )
                  : Container(),
              Container(
                  width: Get.width,
                  child: Center(
                      child: Text(
                    "$qty" + " X " + name,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ))),
              SizedBox(
                height: 6,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: appGet.kelloController.value,
                      autofocus: kReleaseMode,
                      focusNode: appGet.kelloFocus,
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
                            // appGet.barCodeFocus.unfocus();
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await appGet
                          .getPostApi(appGet.kelloController.value.text);
                      print(appGet.subDetails[0]["barcode"]);
                      print(appGet.content01.value);
                      if (appGet.subDetails[0]["barcode"] ==
                          appGet.content01.value) {
                        if (appGet.subDetailsOut.length.toString() !=
                            qty.toString()) {
                          if (unitId == 1) {
                            if (appGet.subDetailsOut
                                .map((element) =>
                                    double.parse(element["weight"]))
                                .toList()
                                .contains(appGet.content310.value)) {
                              Future.delayed(Duration(milliseconds: 500),
                                  () async {
                                Get.dialog(killoAlert());
                              });
                            } else {
                              await appGet.save(
                                  1,
                                  appGet.kelloController.value.text,
                                  widget.idDetail,
                                  widget.idOrder,
                                  widget.idProduct,
                                  unitId,
                                  name);
                              await ApiServer.instance.getSubDetailProductsOut(
                                  widget.idDetail, widget.idOrder.toString());
                              setListWeight();
                            }
                          } else {
                            await appGet.save(
                                1,
                                appGet.kelloController.value.text,
                                widget.idDetail,
                                widget.idOrder,
                                widget.idProduct,
                                unitId,
                                name);
                            await ApiServer.instance.getSubDetailProductsOut(
                                widget.idDetail, widget.idOrder.toString());
                            setListWeight();
                          }
                        } else {
                          setToast("Done All Item", color: Colors.red);
                        }
                      }
                      // appGet.kelloFocus.unfocus();
                      appGet.kelloController.value.text = "";
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          height: 35,
                          width: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
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
                  )
                ],
              ),
              appGet.subDetailsOut.length != 0
                  ? Container(
                      height: Get.height / 1.25.h,
                      child: ListView.separated(
                        separatorBuilder: (_, index2) => SizedBox(height: 2),
                        itemCount: appGet.subDetailsOut.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index2) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            // height: 70.h,
                            decoration: BoxDecoration(
                              color: AppColors.doneColor,
                              // appGet.subDetails[0]['list'][index2]
                              //             ['is_output'] ==
                              //         1
                              //     ? AppColors.doneColor
                              //     : AppColors.newColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "  " + name ?? "",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      decoration: TextDecoration.lineThrough
                                      //  appGet.subDetails[0]['list']
                                      //             [index2]['is_output'] ==
                                      //         1
                                      //     ? TextDecoration.lineThrough
                                      //     : null,
                                      ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 3,
                                      ),
                                      // Spacer(),

                                appGet.subDetailsOut[index2]
                                                    ['batch_num']==null||appGet.subDetailsOut[index2]
                                                    ['batch_num']==""?Container():          Column(
                                        children: [
                                          Text(
                                            "Batch / S.N",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            appGet.subDetailsOut[index2]
                                                    ['batch_num'] ??
                                                "",
                                        
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                              appGet.subDetailsOut[index2]["expiration_date"]==null&&  appGet.subDetailsOut[index2]["production_date"]==null?Container():       Column(
                                        children: [
                                          Text(
                                              appGet.subDetailsOut[index2]
                                                        ["expiration_date"] ==
                                                    null
                                                ? "P-Dato"
                                                : "E-Dato"  ,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            appGet.subDetailsOut[index2]
                                                        ["expiration_date"] ==
                                                    null
                                                ? appGet.subDetailsOut[index2]
                                                        ["production_date"] ??
                                                    ""
                                                : appGet.subDetailsOut[index2]
                                                        ["expiration_date"] ??
                                                    "",
                                     
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Spacer(),

                                      unitId == 1
                                          ? Column(
                                              children: [
                                                Text(
                                                  "Vekt",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  appGet.subDetailsOut[index2]
                                                          ["weight"] ??
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
                                            )
                                          : Container(),
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
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$qty elementer må legges inn",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
              appGet.subDetailsOut.length == 0
                  ? Container()
                  : FlatButton(
                      onPressed: appGet.subDetailsOut.length.toString() !=
                                    appGet.subDetailsOut[0]['stk_count']
                          ? null
                          : () async {
                              await ApiServer.instance.getUpdateProductBarcode(
                                  widget.list[0]["id"]);
                              ApiServer.instance
                                  .getDetailsOrders(widget.idOrder);
                              setToast("Done");
                              Get.back();
                            },
                      child: Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: appGet.subDetailsOut.length.toString() ==
                                    appGet.subDetailsOut[0]['stk_count']
                             
                                ? Colors.green
                                : Colors.grey),
                        child: Center(
                            child: Text(
                          "Ferdig",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                      )),
              SizedBox(
                height: 10,
              ),
            ],
          ));
        }),
      ),
    );
  }

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
                      Navigator.pop(context);
                      appGet.kelloController.value.text = "";
                      SystemChannels.textInput.invokeMethod('TextInput.hide');

                      // appGet.barCodeFocus.unfocus();
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
                        fontSize: 16,
                      )),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      await appGet.save(
                          1,
                          appGet.kelloController.value.text,
                          widget.idDetail,
                          widget.idOrder,
                          widget.idProduct,
                          unitId,
                          name);
                      await ApiServer.instance.getSubDetailProductsOut(
                          widget.idDetail, widget.idOrder.toString());
                      setListWeight();
                      Navigator.pop(context);
                      SystemChannels.textInput.invokeMethod('TextInput.hide');

                      // appGet.barCodeFocus.unfocus();

                      // setState(() {});
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
