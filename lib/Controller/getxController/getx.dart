import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/view/screen/main_screen/new_order_screen.dart';
import 'package:dinengros/view/widget/progress_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppGet extends GetxController {
  RxMap searchList = Map().obs;

  Rx<TextEditingController> barCodeController = TextEditingController().obs;
  Rx<TextEditingController> barCodeInputController =
      TextEditingController().obs;
  Rx<TextEditingController> stkCountController = TextEditingController().obs;
  Rx<TextEditingController> kelloController = TextEditingController().obs;
  Rx<TextEditingController> newOrderController = TextEditingController().obs;
  Rx<TextEditingController> noteController = TextEditingController().obs;
  Rx<TextEditingController> userController = TextEditingController().obs;
  Rx<TextEditingController> idUserController = TextEditingController().obs;
  Rx<TextEditingController> searchCodeController = TextEditingController().obs;
  Rx<TextEditingController> nameProduct = TextEditingController().obs;
  Rx<TextEditingController> quantityController = TextEditingController().obs;

  Rx<TextEditingController> customerPriceController =
      TextEditingController().obs;
  Rx<TextEditingController> searchAlertController = TextEditingController().obs;
  RxString token = "".obs;
  var pr = ProgressDialogUtils.createProgressDialog(Get.context);
  RxString groupApi = "".obs;
  RxString barcodValue = "".obs;
  RxString barCode = "".obs;
  RxString name01 = "".obs;
  RxString content01 = "".obs;
  RxString groupId = ''.obs;
  RxInt lengthBarcod = 0.obs;
  RxString name15 = "".obs;
  RxString name13 = "".obs;
  RxString content13 = "".obs;
  RxString name17 = "".obs;
  RxString content17 = "".obs;
  RxString name37 = "".obs;
  RxString content37 = "".obs;
  RxString name21 = "".obs;
  RxString content21 = "".obs;
  RxInt qtynew = 0.obs;
  RxInt qtyindex = 0.obs;
  RxString name10 = "".obs;
  RxString content10 = "".obs;
  RxString name310 = "".obs;
  RxBool lodaing = false.obs;
  RxBool tokenBool = false.obs;
  RxString content310 = "".obs;
  RxList<double> kello = List<double>().obs;
  RxList<String> exdate = List<String>().obs;
  RxList<String> batchNum = List<String>().obs;
  RxList idlist = List().obs;
  RxString barcod = "".obs;
  RxMap product = {}.obs;
  RxMap productOrder = {}.obs;
  RxMap checkProducts = Map().obs;
  RxList listUnit = List().obs;
  RxList listUser = List().obs;
  RxList listProduct = List().obs;
  RxList<ProductModel> listAddProduct = List<ProductModel>().obs;
  RxList<ProductModel> listInScreen = List<ProductModel>().obs;
  RxList<WhereHouseModel> whereHousScreen = List<WhereHouseModel>().obs;
  RxList listOrders = List().obs;
  RxList listDetailsOrders = List().obs;
  RxList subDetails = List().obs;
  RxList subDetailsOut = List().obs;
  RxList productList = List().obs;
  RxList oList = List().obs;
  RxInt currentSelectedTab = 0.obs;

  Map map = {}.obs;
  RxBool stop = false.obs;
  final FocusNode detailFocus = FocusNode();
  final FocusNode userOrderFocus = FocusNode();
  final FocusNode searchFocus = FocusNode();
  final FocusNode searchAlertFocus = FocusNode();
  final FocusNode newOrderFocus = FocusNode();
  final FocusNode kelloFocus = FocusNode();
  final FocusNode inputFocus = FocusNode();
  Rx<AudioPlayer> audioPlayer = AudioPlayer().obs;
  AudioCache audioCache = AudioCache();
  void playAlert() async {
    if (audioPlayer.value.state != AudioPlayerState.PLAYING) {
      audioPlayer.value.state = AudioPlayerState.PLAYING;
      stop.value = true;
      audioPlayer.value = await audioCache.loop('sounds/alert.mp3');
    }
  }

  void stopAlert() {
    // if (stop) {
    audioPlayer.value.stop();
    audioPlayer.value.state = AudioPlayerState.STOPPED;
    stop.value = false;

    // }
    // if (rangBefore.containsKey(orderCode)) {
    //   rangBefore[orderCode].enable = !rangBefore[orderCode].enable;
    // }
  }

  qty() {
    qtyindex = qtyindex + 1;
  }

  String name;
  getPostApi(String code) async {
    groupApi.value="";
        SystemChannels.textInput.invokeMethod('TextInput.hide');

    await ApiServer.instance.getReaderBarcode(code).then((value) => {
          if (value['type'] == "A")
            {
              content01.value = value['value'],
              name01.value = "Strekkode",
              groupApi.value = value['type'],
              lengthBarcod.value = content01.value.length,
            },
          if (value['list'] != null)
            {
              map = value['list'],
              productList.value = map.keys.toList(),
              if (map.keys.contains("01") == true)
                {
                  name01.value = "Strekkode",
                  content01.value = map["01"]['content'],
                  lengthBarcod.value = map["01"]['length'],
                  product.addAll(
                      {"name01": name01.value, "content01": content01.value})
                },
              if (map.keys.contains("02") == true)
                {
                  name01.value = "Strekkode",
                  content01.value = map["02"]['content'],
                  lengthBarcod.value = map["02"]['length'],
                  product.addAll(
                      {"name02": name01.value, "content02": content01.value})
                },
              if (map.keys.contains("10") == true)
                {
                  name10.value = map["10"]['title'],
                  content10.value = map["10"]['content'],
                  product.addAll(
                      {"name10": name10.value, "content10": content10.value})
                },
              if (map.keys.contains("17") == true)
                {
                  name17.value = map["17"]['title'],
                  content17.value = map["17"]['content']["date"],
                  product.addAll({
                    "name17": name17.value,
                    "content17": content17.value.substring(0, 10)
                  })
                },
              if (map.keys.contains("15") == true)
                {
                  name15.value = map["15"]['title'],
                  content17.value = map["15"]['content']['date'],
                  product.addAll({
                    "name15": name15.value,
                    "content15": content17.value.substring(0, 10)
                  })
                },
              if (map.keys.contains("12") == true)
                {
                  name13.value = map["12"]['title'],
                  content13.value = map["12"]['content']['date'],
                  product.addAll({
                    "name12": name13.value,
                    "content12": content13.value.substring(0, 10)
                  })
                },
              if (map.keys.contains("11") == true)
                {
                  name13.value = map["11"]['title'],
                  content13.value = map["11"]['content']['date'],
                  product.addAll({
                    "name11": name13.value,
                    "content11": content13.value.substring(0, 10)
                  })
                },
              if (map.keys.contains("310") == true)
                {
                  name310.value = map["310"]['title'],
                  content310.value = map["310"]['content'].toString(),
                  product.addAll({
                    "name310": name310.value,
                    "content310": content310.value.toString()
                  }),
                },
              if (map.keys.contains("21") == true)
                {
                  name10.value = map["21"]['title'],
                  content10.value = map["21"]['content'],
                  product.addAll(
                      {"name21": name10.value, "content21": content10.value}),
                },
              if (map.keys.contains("37") == true)
                {
                  name37.value = map["37"]['title'],
                  content37.value = map["37"]['length'].toString(),
                  product.addAll(
                      {"name37": name37.value, "content37": content37.value}),
                },
              if (map.keys.contains("21") == true)
                {
                  name21.value = map["21"]['title'],
                  content21.value = map["21"]['length'].toString(),
                  product.addAll(
                      {"name21": name21.value, "content21": content21.value}),
                },
            },
          if (map.keys.contains("13") == true)
            {
              name13.value = map["13"]['title'],
              content13.value = map["13"]['content'] == null
                  ? ""
                  : map["13"]['content']['date'],
              product.addAll(
                  {"name13": name13.value, "content13": content13.value})
            },
        });
  }

  save(int qty, String barcode, int idOrderDetail, int orderId,
      int selectedProductID, int unitId, String name) async {
    await ApiServer.instance
        .getSaveOrder(
            orderDetailId: idOrderDetail,
            orderId: orderId,
            productId: selectedProductID,
            unitId: unitId,
            barcode: content01.value,
            pdate: content13.value,
            barcodeAfter: barcode,
            exdate: content17.value,
            batchNum: content10.value,
            productName: name,
            qty: qty,
            moveType: "output",
            kilo: content310.value.toString(),
            stkcount: stkCountController.value.text)
        .then(
            (value) => SystemChannels.textInput.invokeMethod('TextInput.hide'));

    //     .then((value) {
    //   SystemChannels.textInput.invokeMethod('TextInput.hide');

    //   // OverlayScreen().pop();
    //   // scrollController
    //   //     .animateTo(0.0,
    //   //         duration: Duration(milliseconds: 200), curve: Curves.easeIn)
    //   //     .whenComplete(() {
    //   //   FocusScope.of(Get.context).requestFocus(appGet.barCodeFocus);
    //   // });
    // });
  }

  AppGet() {
    // Future.delayed(Duration(seconds: 1)).then((value) async{

    barCodeController.value.addListener(() async {
      if (barCodeController.value.text.isEmpty) {
        FocusScope.of(Get.context).unfocus();
      } else {
        // SystemChannels.textInput.invokeMethod('TextInput.hide');
        // FocusScope.of(Get.context).unfocus();
      }
    });
    kelloController.value.addListener(() async {
      if (kelloController.value.text.isEmpty) {
        FocusScope.of(Get.context).unfocus();
      } else {
        FocusScope.of(Get.context).unfocus();
        // getOrders();
      }
    });
    // });
  }

  List ll;
  List getList(int i) {
    switch (i) {
      case 2:
        ll = listOrders.where((e) => e['status_id'] == 2).toList();

        break;
      case 4:
        ll = listOrders.where((e) => e['status_id'] == 2).toList();

        break;
      case 6:
        ll = listOrders.where((e) => e['status_id'] == 2).toList();

        break;
      default:
    }
    return ll;
  }

  void clear() {
    barCodeController.value.text = "";
    stkCountController.value.text = "";
    product.clear();
    productList.clear();
    content01.value = "";
    content10.value = "";
    content01.value = "";
    content310.value = "";
    content13.value = "";
    name01.value = "";
    name10.value = "";
    name01.value = "";
    name310.value = "";
    name15.value = "";
    groupApi.value = "";
    barcodValue.value = "";
    nameProduct.value.text = "";
    barcodValue.value = "";
  }
}
