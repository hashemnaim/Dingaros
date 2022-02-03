import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/custom_image.dart';
import 'package:dinengros/view/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widget/item_list.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  AppController appGet = Get.find();

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
    return Background(
        back: true,
        notfi: true,
        contant: Column(mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 4.h,
              ),
              Expanded(
                child: DefaultTabController(
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
                    return Column(
                      children: [
                        Container(
                          height: 27.h,
                          width: Get.width,
                          color: AppColors.primary2,
                          child: Center(
                            child: TabBar(
                              controller: _tabController,
                              indicator: BoxDecoration(),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.black,
                              tabs: [
                                Tab(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            height: 4,
                                          )
                                        : Container(),
                                    currentSelectedTab == 0
                                        ? CustomSvgImage(
                                            imageName: "next",
                                            fit: BoxFit.contain,
                                            height: 12,
                                            color: Colors.white,
                                          )
                                        : Container()
                                  ],
                                )),
                                Tab(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            height: 12,
                                            color: Colors.white,
                                          )
                                        : Container()
                                  ],
                                )),
                                Tab(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            height: 12,
                                            color: Colors.white,
                                          )
                                        : Container()
                                  ],
                                )),
                              ],
                              onTap: (index) {
                                currentSelectedTab = index;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              // margin: EdgeInsets.only(top: 35.h),
                              // color: Colors.amber,
                              // height: Get.height / 0.6.h,
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
                                text: "Det er ingen fullførte forespørsler",
                                statusId: 3,
                              ),
                              ItemTap(
                                type: 3,
                                color: Color(0xffF7E5E5),
                                text: "Ingen forespørsler kansellert",
                                statusId: 6,
                              ),
                            ],
                          )),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ]));

    // );
  }
}
