import 'dart:convert';

import 'package:dinengros/Controller/helper/sp_helper.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/screen/main_screen/home_screen.dart';
import 'package:dinengros/view/screen/main_screen/new_order_screen.dart';
import 'package:dio/dio.dart';
import 'package:dinengros/Controller/getxController/getx.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as getx;

class ApiServer {
  ApiServer._();
  static ApiServer instance = ApiServer._();
  Dio dio;

  Dio initApi() {
    if (dio == null) {
      dio = Dio();
      return dio;
    } else {
      return dio;
    }
  }

  String baseUrl = "https://mecm.org.uk/api/";
  AppGet appGet = getx.Get.find();
  getApi() async {
    getAllProduct();
    getUnits();
    getCheckProducts();
    getAllUser();
    await getOrders();
  }

  Future<Map> signInServer({String email, String password}) async {
    dio = initApi();
    appGet.pr.show();
    try {
      FormData data = FormData.fromMap({
        'login': email,
        'password': password,
      });
      Response response = await dio.post("$baseUrl" + "adminLogin", data: data);

      if (response.statusCode == 200) {
        await SPHelper.spHelper.setToken(response.data['data']['auth_token']);
        await SPHelper.spHelper
            .setText("name", response.data['data']['first_name']);
        appGet.token.value = response.data['data']['auth_token'];
        await ApiServer.instance.getApi();
        appGet.pr.hide();
        getx.Get.offAll(() => HomeScreen());
      }
      return response.data[0];
    } catch (e) {
      appGet.pr.hide();

      return null;
    }
  }
////////////////////////////////////////////////////////////////

  Future<Map> getReaderBarcode(String barcode) async {
    appGet.lodaing.value = true;
    dio = initApi();
    try {
      FormData data = FormData.fromMap({
        'barcode': barcode,
        'auth_token': appGet.token.value,
      });
      Response response =
          await dio.post("$baseUrl" + "barcode-reader", data: data);
      appGet.lodaing.value = false;
      return response.data[0];
    } catch (e) {
      appGet.lodaing.value = false;
      return null;
    }
  }

////////////////////////////////////////////////////////////////

  Future<Map> getCheckProducts() async {
    appGet.lodaing.value = true;
    dio = initApi();
    try {
      FormData data = FormData.fromMap({
        'auth_token': appGet.token.value,
      });
      Response response =
          await dio.post("$baseUrl" + "check-products", data: data);
      print(response.data);
      appGet.lodaing.value = false;
      appGet.checkProducts.assignAll(response.data);

      return response.data;
    } catch (e) {
      appGet.lodaing.value = false;
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////

  Future getSubDetailsProduct(
    int detailId,
    String orderId,
  ) async {
    appGet.lodaing.value = true;
    dio = initApi();
    try {
      FormData data = FormData.fromMap({
        'detail_id': detailId.toString(),
        'order_id': orderId.toString(),
        'auth_token': appGet.token.value,
      });
      Response response =
          await dio.post("$baseUrl" + "output-order", data: data);
      appGet.lodaing.value = false;
      print("getSubDetail : " + response.data.toString());
      appGet.subDetails.assignAll(response.data);
      return response.data;
    } catch (e) {
      appGet.lodaing.value = false;
      return null;
    }
  } ////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
  Future getSubDetailProductsOut(
    int detailId,
    String orderId,
  ) async {
    print(detailId);
    print(orderId);
    appGet.lodaing.value = true;
    dio = initApi();
    try {
      FormData data = FormData.fromMap({
        'detail_id': detailId.toString(),
        'order_id': orderId.toString(),
        'auth_token': appGet.token.value,
      });
      Response response =
          await dio.post("$baseUrl" + "order-warehouse-output", data: data);
      appGet.lodaing.value = false;
      print("getSubDetail 2: " + response.data.toString());
      appGet.subDetailsOut.assignAll(response.data);
      return response.data;
    } catch (e) {
      appGet.lodaing.value = false;
      return null;
    }
  }

////////////////////////////////////////////////////////////////

  Future<List> getAllProduct() async {
    dio = initApi();
    try {
      Response response = await dio.post("$baseUrl" + "all-products", data: {
        'auth_token': appGet.token.value,
      });
      appGet.listProduct.addAll(response.data);
      return response.data;
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  Future<List> getOrders() async {
    dio = initApi();
    appGet.lodaing.value = true;
    try {
      Response response = await dio.post("$baseUrl" + "orders",
          data: {'auth_token': appGet.token.value});
      appGet.lodaing.value = false;
      appGet.tokenBool.value = true;
      print(response.data);
      appGet.listOrders.assignAll(response.data);
      return response.data;
    } catch (e) {
      appGet.tokenBool.value = false;

      appGet.lodaing.value = false;
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  Future<List> getLogout() async {
    dio = initApi();
    appGet.lodaing.value = true;
    try {
      Response response = await dio.post("$baseUrl" + "adminLogout",
          data: {'auth_token': appGet.token.value});

      return response.data;
    } catch (e) {
      appGet.tokenBool.value = false;

      appGet.lodaing.value = false;
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  Future getDetailsOrders(int orderId) async {
    dio = initApi();
    // appGet.pr.show();
    appGet.tokenBool.value = true;
    try {
      Response response = await dio.post("$baseUrl" + "order-details",
          data: {'auth_token': appGet.token.value, "order_id": orderId});
      print(response.data);
      appGet.listDetailsOrders.assignAll(response.data);
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      return response.data;
    } catch (e) {
      return null;
    }
  }

  ////////////////////////////////////////////
  Future getSearchProduct(String barcode) async {
    dio = initApi();
    appGet.tokenBool.value = true;
    try {
      Response response = await dio.post("$baseUrl" + "product-data",
          data: {'auth_token': appGet.token.value, "barcode": barcode});
      if (response.data["status"] == "false") {
        setToast(response.data["massage"]);
        appGet.searchList.clear();
        return response.data;
      } else {
        appGet.searchList.assignAll(response.data);
        return response.data;
      }
    } catch (e) {
      // appGet.tokenBool.value = false;

      return null;
    }
  }

////////////////////////////////////////////////////////////////
  Future<List> getUnits() async {
    dio = initApi();
    try {
      Response response = await dio.post("$baseUrl" + "units", data: {
        'auth_token': appGet.token.value,
      });

      appGet.listUnit.assignAll(response.data);
      return response.data;
    } catch (e) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  Future<List> getAllUser() async {
    dio = initApi();
    try {
      Response response = await dio.post("$baseUrl" + "all-users", data: {
        'auth_token': appGet.token.value,
      });
      print(response.data);
      appGet.listUser.assignAll(response.data);
      return response.data;
    } catch (e) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  Future<List> getOutCreatOrder(List<WhereHouseModel> whereHous) async {
    dio = initApi();
    String jsonhous = jsonEncode(whereHous);

    try {
      Response response =
          await dio.post("$baseUrl" + "output-order-warehouse", data: {
        'auth_token': appGet.token.value,
        'warehouse': jsonhous,
      });
      print(response.data);
      setToast("Done");

      // appGet.listUser.assignAll(response.data);
      return response.data;
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  Future<Map> getUpdateProductBarcode(int id) async {
    dio = initApi();
    print(id);
    try {
      Response response =
          await dio.post("$baseUrl" + "update-scan-barcode", data: {
        'auth_token': appGet.token.value,
        'is_sacn_barcode': 1,
        'id': id,
      });

      print(response.data);
      await getOrders();

      return response.data;
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  Future<Map> getUpdateCheck(int productId, int status, String note) async {
    dio = initApi();
    print(productId);
    print(status);
    print(note);
    try {
      Response response = await dio.post("$baseUrl" + "update-check", data: {
        'auth_token': appGet.token.value,
        'product_id': productId,
        'status': status,
        'note': note,
      });
      print(response.data);
      appGet.noteController.value.text = "";
      appGet.searchCodeController.value.text = "";
              SystemChannels.textInput.invokeMethod('TextInput.hide');

      await getCheckProducts();

      return response.data;
    } catch (e) {
      return null;
    }
  }

  //////////////////////////////////////////////////////////

  Future<Map> getUpdateOrders(int id) async {
    dio = initApi();
    // appGet.pr.show();
    try {
      Response response =
          await dio.post("$baseUrl" + "update-order-status", data: {
        'auth_token': appGet.token.value,
        'status_id': 4,
        'id': id,
      });
      await getOrders();
      // appGet.pr.hide();

      return response.data;
    } catch (e) {
      appGet.pr.hide();

      return null;
    }
  }

////////////////////////////////////////////////////////////////
  Future<Map> getSaveOrder({
    int productId,
    int orderId,
    int orderDetailId,
    int unitId,
    String barcode,
    String pdate,
    String exdate,
    String barcodeAfter,
    String productName,
    String batchNum,
    String stkcount,
    int qty,
    String kilo,
    String moveType,
  }) async {
    dio = initApi();

    try {
      FormData data = FormData.fromMap({
        'auth_token': appGet.token.value,
        'product_id': productId,
        'order_id': orderId ?? 0,
        'order_detail_id': orderDetailId ?? 0,
        'unit_id': unitId,
        'supplier_id': 1,
        'move_type': moveType,
        'qty': qty,
        'barcode': barcode,
        'barcode_after_analyz': barcodeAfter,
        'production_date': pdate,
        'expiration_date': exdate,
        'name': productName,
        'stk_count': stkcount,
        'batch_num': batchNum,
        'weight': kilo,
      });
      Response response =
          await dio.post("$baseUrl" + "store-to-warehouse", data: data);
      print(response.data);
      setToast("Done");
      appGet.barCodeController.value.text = "";
      appGet.barCodeInputController.value.text = "";
      appGet.kelloController.value.text = "";
      appGet.content17.value = "";
      appGet.content21.value = "";
      appGet.content10.value = "";
      appGet.barcodValue.value = "";
      appGet.content01.value = "";
      appGet.lengthBarcod.value = 0;
      appGet.content310.value = "";
      appGet.nameProduct.value.text = "";

      return response.data;
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  Future getCreatOrder({
    int userId,
    // List<ProductModel> product,
    List<WhereHouseModel> whereHous,
  }) async {
    dio = initApi();
    // String jsonTags = jsonEncode(product);
    String jsonhous = jsonEncode(whereHous);

    // print(userId);
    print(jsonhous);

    try {
      FormData data = FormData.fromMap({
        'auth_token': appGet.token.value,
        'user_id': userId,
        'shipping_id': 1,
        'delivery_date': DateTime.now().toString() ?? "",
        'warehouse': jsonhous,
      });
      Response response =
          await dio.post("$baseUrl" + "create-order", data: data);
      print(response.data);

      appGet.nameProduct.value.text = "";
      appGet.userController.value.text = "";
      appGet.idUserController.value.text = "";
      appGet.listAddProduct.clear();
      appGet.listInScreen.clear();
      appGet.whereHousScreen.clear();

      return response.data;
    } catch (e) {
      return null;
    }
  }
}
