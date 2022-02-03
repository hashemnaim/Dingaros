import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/value/colors.dart';
import 'package:dinengros/view/widget/isload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FloatingCustom extends StatefulWidget {
  @override
  _FloatingCustomState createState() => _FloatingCustomState();
}

class _FloatingCustomState extends State<FloatingCustom> {
  AppController appGet = Get.find();

  @override
  void initState() {
    appGet.searchAlertController.value.text = '';
    Future.delayed(Duration(milliseconds: 1)).then(
        (value) => SystemChannels.textInput.invokeMethod('TextInput.hide'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        shape: Border.all(color: Colors.transparent),
        splashColor: AppColors.primary,
        onPressed: () {
          appGet.productModel.value = null;
          appGet.tokenBool.value = false;

          Get.dialog(StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                title: Obx(
              () => Column(
                children: [
                  TextFormField(
                    controller: appGet.searchAlertController.value,
                    autofocus: true,
                    focusNode: appGet.searchAlertFocus,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (v) async {
                      await Future.delayed(Duration(milliseconds: 300));
                      await appGet
                          .getPostApi(appGet.searchAlertController.value.text);
                      print("/////////////");
                      print(appGet.content01.value);
                      await ApiServer.instance
                          .getSearchProduct(appGet.content01.value);
                      // appGet.searchAlertController.value.text = '';
                      // setState(() {});
                      // appGet.searchAlertFocus.unfocus();

                      Future.delayed(Duration(milliseconds: 10)).then((value) =>
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide'));
                    },
                    decoration: InputDecoration(
                      hintText: "Strekkode",
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 2,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      fillColor: Colors.black,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          appGet.productModel.value = null;
                          appGet.searchAlertController.value.text = '';
                          Future.delayed(Duration(milliseconds: 1)).then(
                              (value) => SystemChannels.textInput
                                  .invokeMethod('TextInput.hide'));
                        },
                      ),
                    ),
                  ),
                  appGet.productModel.value == null
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              appGet.productModel.value.name ?? "",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            appGet.productModel.value.prices == null
                                ? Container()
                                : appGet.productModel.value.prices.list
                                            .length ==
                                        0
                                    ? Container()
                                    : Container(
                                        height: double.parse((20 *
                                                appGet.productModel.value.prices
                                                    .list.length)
                                            .toString()),
                                        width: 300,
                                        // appGet.searchList["prices"].length,
                                        child: ListView.builder(
                                          itemCount: appGet.productModel.value
                                              .prices.list.length,
                                          itemBuilder: (context, index) => Text(
                                            "Pris : " +
                                                    appGet
                                                        .productModel
                                                        .value
                                                        .prices
                                                        .list[index]
                                                        .price
                                                        .floorToDouble()
                                                        .toString() +
                                                    " " +
                                                    appGet
                                                        .productModel
                                                        .value
                                                        .prices
                                                        .list[index]
                                                        .unit ??
                                                "",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),

                            // SizedBox(
                            //   height: 10,
                            // ),
                          ],
                        ),
                  FlatButton(
                      color: AppColors.primary2,
                      onPressed: () async {
                        await appGet.getPostApi(
                            appGet.searchAlertController.value.text);
                        await ApiServer.instance
                            .getSearchProduct(appGet.content01.value);
                        appGet.searchAlertController.value.text = '';
                      },
                      child: Obx(() => appGet.tokenBool.value == true
                          ? IsLoad()
                          : Text(
                              "Søk",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )))
                ],
              ),
            )),
          ));
        },
        child: CircleAvatar(
            radius: 25,
            child: Text("?",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            backgroundColor: AppColors.primary2));
  }
}
