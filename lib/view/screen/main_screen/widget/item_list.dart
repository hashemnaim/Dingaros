import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/Controller/getxController/getx.dart';
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
  AppGet appGet = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          appGet.listOrders.length == 0
              ? Center(
                  child:
                      Expanded(child: Center(child: CustomText("No orders"))))
              : appGet.listOrders
                          .where((e) => e['status_id'] == widget.statusId)
                          .toList()
                          .length ==
                      0
                  ? Center(
                      child: CustomText(
                      widget.text,
                      fontSize: 14.sp,
                    ))
                  : Container(
                      // height: 80.h,
                      height: Get.height / 1.4.h,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          setState(() {});
                          appGet.stopAlert();

                          return await ApiServer.instance.getOrders();
                        },
                        child: ListView.separated(
                            // primary: false,
                            // shrinkWrap: true,
                            separatorBuilder: (_, index) =>
                                SizedBox(height: 8.h),
                            itemCount: appGet.listOrders
                                .where((e) => e['status_id'] == widget.statusId)
                                .toList()
                                .length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () async {
                                    appGet.barCodeController.value.text = "";

                                    await ApiServer.instance.getDetailsOrders(
                                        appGet
                                            .listOrders
                                            .where((e) =>
                                                e['status_id'] ==
                                                widget.statusId)
                                            .toList()[index]['id']);

                                    Get.to(() => DetailsOrdersList(
                                          statusId: widget.statusId,
                                        ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: widget.type == 1
                                          ? appGet.listOrders
                                                      .where((e) =>
                                                          e['status_id'] ==
                                                          widget.statusId)
                                                      .toList()[index]
                                                          ["orderDetails"]
                                                      .where((element) =>
                                                          element[
                                                              "is_sacn_barcode"] ==
                                                          1)
                                                      .toList()
                                                      .length ==
                                                  0
                                              ? widget.color
                                              //
                                              : Colors.grey[200]
                                          : widget.color,
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
                                                    appGet.listOrders
                                                        .where((e) =>
                                                            e['status_id'] ==
                                                            widget.statusId)
                                                        .toList()[index]['code']
                                                        .toString(),
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: Text(
                                                  appGet.listOrders
                                                      .where((e) =>
                                                          e['status_id'] ==
                                                          widget.statusId)
                                                      .toList()[index]['user']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Text(
                                            appGet.listOrders
                                                .where((e) =>
                                                    e['status_id'] ==
                                                    widget.statusId)
                                                .toList()[index]["orderDetails"]
                                                .length
                                                .toString(),
                                            style: GoogleFonts.montserrat(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffA9AAAA),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                      ),
                    ),
          SizedBox(
            height: 10,
          )
        ],
      );
    });
  }
}
