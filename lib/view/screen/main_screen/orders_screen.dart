import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/custom_image.dart';
import 'package:dinengros/view/widget/custom_text.dart';
import 'package:dinengros/view/widget/isload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Controller/getxController/getx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'detail_orders_screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  AppGet appGet = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int currentSelectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Background(
          back: true,
          notfi: true,
          contant: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                DefaultTabController(
                  initialIndex: 0,
                  length: 3,
                  child: Builder(builder: (context) {
                    _tabController = DefaultTabController.of(context);
                    _tabController.addListener(() {
                      if (!_tabController.indexIsChanging) {
                        print(_tabController.index);
                        appGet.pr.show();
                        currentSelectedTab = _tabController.index;
                        Future.delayed(Duration(seconds: 1), () async {
                          appGet.pr.hide();
                        });
                        setState(() {});
                      }
                    });
                    return Obx(
                      () => Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 35.h),
                            // color: Colors.amber,
                            height: Get.height / 0.8.h,
                            child: TabBarView(
                              children: [
                                tabItem(
                                  orders: appGet.listOrders
                                      .where((e) => e['status_id'] == 2)
                                      .toList(),
                                  color: Color(0xffF7F4E5),
                                  type: 1,
                                  text: "Det er ingen nye forespørsler",
                                  statusId: 2,
                                ),
                                tabItem(
                                  orders: appGet.listOrders
                                      .where((e) => e['status_id'] == 4)
                                      .toList(),
                                  color: Color(0xffEBF7E5),
                                  type: 2,
                                  text: "Det er ingen fullførte forespørsler",
                                  statusId: 4,
                                ),
                                tabItem(
                                  orders: appGet.listOrders
                                      .where((e) => e['status_id'] == 6)
                                      .toList(),
                                  type: 3,
                                  color: Color(0xffF7E5E5),
                                  text: "Ingen forespørsler kansellert",
                                  statusId: 6,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Container(
                              height: 27.h,
                              width: Get.width,
                              color: AppColors.primary2,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 8,
                            child: TabBar(
                              controller: _tabController,
                              indicator: BoxDecoration(),
                              // BubbleTabIndicator(),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      'Ny ordre',
                                      color: Color(0xffD8D8D8),
                                      fontSize:
                                          currentSelectedTab == 0 ? 16 : 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    currentSelectedTab == 0
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : Container(),
                                    currentSelectedTab == 0
                                        ? CustomSvgImage(
                                            imageName: "next",
                                            fit: BoxFit.contain,
                                            height: 14,
                                          )
                                        : Container()
                                  ],
                                )),
                                Tab(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      'Ferdig',
                                      color: Color(0xffD8D8D8),
                                      fontSize:
                                          currentSelectedTab == 1 ? 16 : 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    currentSelectedTab == 1
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : Container(),
                                    currentSelectedTab == 1
                                        ? CustomSvgImage(
                                            imageName: "next",
                                            fit: BoxFit.contain,
                                            height: 14,
                                          )
                                        : Container()
                                  ],
                                )),
                                Tab(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      'Kansellert',
                                      color: Color(0xffD8D8D8),
                                      fontSize:
                                          currentSelectedTab == 2 ? 14 : 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    currentSelectedTab == 2
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : Container(),
                                    currentSelectedTab == 2
                                        ? CustomSvgImage(
                                            imageName: "next",
                                            fit: BoxFit.contain,
                                            height: 14,
                                          )
                                        : Container()
                                  ],
                                )),
                              ],
                              onTap: (index) {
                                currentSelectedTab = index;
                                print(currentSelectedTab);
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ]))),
    );

    // );
  }

  Widget tabItem(
      {List orders, Color color, String text, int type, int statusId}) {
    return 
        
         RefreshIndicator(
            onRefresh: () async {
              return await ApiServer.instance.getOrders();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                        appGet.listOrders.length==0?Center(child: Expanded(child: Center(child: CustomText("No orders")))):

                Expanded(
                  child: orders.length == 0
                      ? Center(
                          child: CustomText(
                          text,
                          fontSize: 14.sp,
                        ))
                      : Container(
                          height: 80.h,
                          // height:Get.height/3 ,
                          child: ListView.separated(
                              separatorBuilder: (_, index) =>
                                  SizedBox(height: 8),
                              itemCount: orders.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () async {
                                      appGet.barCodeController.value.text = "";
                                      print(orders[index]['id']);

                                      await ApiServer.instance.getDetailsOrders(
                                          orders[index]['id']);

                                      Get.to(() => DetailsOrdersList(
                                            statusId: statusId,
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: type == 1
                                            ? orders[index]["orderDetails"]
                                                        .where((element) =>
                                                            element[
                                                                "is_sacn_barcode"] ==
                                                            1)
                                                        .toList()
                                                        .length ==
                                                    0
                                                ? color
                                                //
                                                : Colors.grey[200]
                                            : color,
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
                                                      orders[index]['code']
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: Text(
                                                    orders[index]['user']
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
                                              orders[index]["orderDetails"]
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
            ),
          );
  }
}
