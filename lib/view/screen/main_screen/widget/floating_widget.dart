import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/Controller/getxController/getx.dart';
import 'package:dinengros/value/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FloatingCustom extends StatefulWidget {
  @override
  _FloatingCustomState createState() => _FloatingCustomState();
}

class _FloatingCustomState extends State<FloatingCustom> {
  AppGet appGet = Get.find();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    appGet.searchAlertController.value.text = '';

    appGet.newOrderFocus.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        shape: Border.all(color: Colors.transparent),
        splashColor: AppColors.primary,
        onPressed: () {
          appGet.searchList.clear();
          Get.dialog(AlertDialog(
              title: Obx(
            () => SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: appGet.searchAlertController.value,
                    autofocus: kReleaseMode,
                    focusNode: appGet.searchAlertFocus,
                    keyboardType: TextInputType.text,
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
                          appGet.searchList.clear();
                          appGet.searchAlertController.value.text = '';
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  appGet.searchList.isEmpty || appGet.searchList["name"] == null
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              appGet.searchList["name"] ?? "",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            appGet.searchList["prices"].length == 0 ||
                                    appGet.searchList["prices"] == null
                                ? Container()
                                : Container(
                                    height: double.parse((20 *
                                            appGet.searchList["prices"].length)
                                        .toString()),
                                    width: 300,
                                    // appGet.searchList["prices"].length,
                                    child: ListView.builder(
                                      itemCount:
                                          appGet.searchList["prices"].length,
                                      itemBuilder: (context, index) => Text(
                                        "Pris : " +
                                                appGet.searchList["prices"]
                                                        [index]["price"]
                                                    .toString() +
                                                " " +
                                                appGet.searchList["prices"]
                                                    [index]["unit"] ??
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
                        print("dddd");
                        await appGet.getPostApi(
                            appGet.searchAlertController.value.text);
                        await ApiServer.instance
                            .getSearchProduct(appGet.content01.value);
                        appGet.searchAlertController.value.text = '';
                      },
                      child: Text(
                        "Søk",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ))
                ],
              ),
            ),
          )));
        },
        child: CircleAvatar(
            radius: 25,
            child: Text("?",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            //  Icon(
            //   Icons.info_outline,
            //   color: Colors.white,
            //   size: 40,
            // ),
            backgroundColor: AppColors.primary2));
  }
}
