import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/view/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../detail_orders_screen.dart';

class ItemTap extends StatefulWidget {
  final Color color;
  final String text;
  final int type;
  final int statusId;
  ItemTap({this.color, this.text, this.type, this.statusId});
  @override
  _ItemTapState createState() => _ItemTapState();
}

class _ItemTapState extends State<ItemTap> {
  AppController appGet = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(appGet.groupId);
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            appGet.orderModel.value.data == null
                ? Container(
                    height: Get.height / 1.6,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 10,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.4))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        height: 10,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.4)))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ]))
                : appGet.orderModel.value.data.length == 0
                    ? Center(child: CustomText("No orders"))
                    : appGet.orderModel.value.data
                                .where((e) => e.statusId == widget.statusId)
                                .toList()
                                .length ==
                            0
                        ? Center(
                            child: CustomText(
                            widget.text,
                            fontSize: 14.sp,
                          ))
                        : Container(
                            child: ListView.separated(
                                primary: false,
                                shrinkWrap: true,
                                separatorBuilder: (_, index) =>
                                    SizedBox(height: 8.h),
                                itemCount: appGet.orderModel.value.data
                                    .where((e) => e.statusId == widget.statusId)
                                    .toList()
                                    .length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return RefreshIndicator(
                                    onRefresh: () async {
                                      // setState(() {});
                                      appGet.stopAlert();

                                      return await ApiServer.instance
                                          .getOrders();
                                    },
                                    child: InkWell(
                                        onTap: () async {
                                          appGet.barCodeController.value.text =
                                              "";
                                          appGet.listDetailsOrders.value
                                              .orderDetails = null;
                                          // if(appGet.listDetailsOrders.value.orderDetails!=null){
                                          // appGet.listDetailsOrders.value.orderDetails.clear();

                                          // }
// print(appGet
//                                           .listOrders
//                                           .where((e) =>
//                                               e['status_id'] == widget.statusId)
//                                           .toList()[index]['id']);
                                          int idOrder = appGet
                                              .orderModel.value.data
                                              .where((e) =>
                                                  e.statusId == widget.statusId)
                                              .toList()[index]
                                              .id;
                                          ApiServer.instance
                                              .getDetailsOrders(idOrder);
                                          Get.to(() => DetailsOrdersList(
                                                statusId: widget.statusId,
                                                idOrder: idOrder,
                                              ));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  //          widget.type == 1
                                                  //             ? appGet.listOrders
                                                  //                         .where((e) =>
                                                  //                             e['status_id'] ==widget.statusId)
                                                  //                         .toList()[index]["orderDetails"]
                                                  //                         .where((element) =>
                                                  //                             element[
                                                  //                                 "is_sacn_barcode"] ==
                                                  //                             1)
                                                  //                         .toList()
                                                  //                         .length ==
                                                  //                     0
                                                  //                 ? widget.color

                                                  //         :
                                                  Colors.grey[200]
                                              //     : widget.color,
                                              ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      "  #" +
                                                          appGet.orderModel
                                                              .value.data
                                                              .where((e) =>
                                                                  e.statusId ==
                                                                  widget
                                                                      .statusId)
                                                              .toList()[index]
                                                              .code
                                                              .toString(),
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12.0),
                                                      child: Text(
                                                        appGet.orderModel.value
                                                            .data
                                                            .where((e) =>
                                                                e.statusId ==
                                                                widget.statusId)
                                                            .toList()[index]
                                                            .user
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  appGet.orderModel.value.data
                                                      .where((e) =>
                                                          e.statusId ==
                                                          widget.statusId)
                                                      .toList()[index]
                                                      .count
                                                      .toString(),
                                                  // appGet.listOrders[index]["count"].toString(),

                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xffA9AAAA),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  );
                                }),
                          ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      );
    });
  }
}
