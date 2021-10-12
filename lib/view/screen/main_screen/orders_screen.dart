import 'package:dinengros/value/colors.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/custom_image.dart';
import 'package:dinengros/view/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/getxController/getx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widget/item_list.dart';

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

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }
  int currentSelectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          print(appGet.listOrders.value.length);
          return Background(
              back: true,
              notfi: true,
              contant: SingleChildScrollView(
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    SizedBox(
                      height: 4.h,
                    ),
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
                        return Stack(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 35.h),
                                // color: Colors.amber,
                                height: Get.height / 0.6.h,
                                child: TabBarView(
                                  children: [
                                    ItemTap(
                                      color: Color(0xffF7F4E5),
                                      type: 1,
                                      text: "Det er ingen nye forespørsler",
                                      statusId: 2,
                                    ),
                                    ItemTap(
                                      color: Color(0xffEBF7E5),
                                      type: 2,
                                      text:
                                          "Det er ingen fullførte forespørsler",
                                      statusId: 3,
                                    ),
                                    ItemTap(
                                      type: 3,
                                      color: Color(0xffF7E5E5),
                                      text: "Ingen forespørsler kansellert",
                                      statusId: 4,
                                    ),
                                  ],
                                )),
                            Positioned(
                              child: Container(
                                height: 27.h,
                                width: Get.width,
                                color: AppColors.primary2,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 8.h,
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
                        );
                      }),
                    ),
                  ])));
        }));

    // );
  }
}
