import 'dart:convert';

import 'package:dinengros/Controller/helper/sp_helper.dart';
import 'package:dinengros/controller/getxController/appController.dart';
import 'package:dinengros/model/all_product_model.dart';
import 'package:dinengros/model/order_delailt.dart';
import 'package:dinengros/model/order_model.dart';
import 'package:dinengros/model/product_model.dart';
import 'package:dinengros/model/status_model.dart';
import 'package:dinengros/value/const.dart';
import 'package:dinengros/view/screen/auth_screen/sign_in_screen.dart';
import 'package:dinengros/view/screen/main_screen/home_screen.dart';
import 'package:dinengros/view/screen/main_screen/new_order_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  String baseUrl = "https://dinengros.no/api/";
  // String baseUrl = "https://coolnetnorge.com/dinengros_v2/api/";
  AppController appGet = getx.Get.find();

  Future<Map> signInServer({String email, String password}) async {
    dio = initApi();
    appGet.pr.show();
    try {
      FormData data = FormData.fromMap({
        'login': email,
        'password': password,
      });
      Response response = await dio.post("$baseUrl" + "adminLogin", data: data);

      await SPHelper.spHelper.setToken(response.data['data']['auth_token']);
      await SPHelper.spHelper
          .setText("name", response.data['data']['first_name']);
      appGet.fetchApi();
      getx.Get.offAll(() => HomeScreen());
      return response.data[0];
    } catch (e) {
      return null;
    }
  }
////////////////////////////////////////////////////////////////

  Future<Map> getReaderBarcode(String barcode) async {
    appGet.lodaing.value = true;
    dio = initApi();
    // try {
    FormData data = FormData.fromMap({
      'barcode': barcode,
      'auth_token': SPHelper.spHelper.getToken(),
    });
    Response response =
        await dio.post("$baseUrl" + "barcode-reader", data: data);
    appGet.lodaing.value = false;
    print(response.data[0]);
    return response.data[0];
    // } catch (e) {
    //   appGet.lodaing.value = false;
    //   return null;
    // }
  }

////////////////////////////////////////////////////////////////

  getReaderBarcodeBatch(String barcode) async {
    appGet.lodaing.value = true;
    dio = initApi();
    print(barcode);
    try {
      FormData data = FormData.fromMap({
        'barcode': barcode,
        'auth_token': SPHelper.spHelper.getToken(),
      });
      Response response =
          await dio.post("$baseUrl" + "barcode-reader", data: data);
      appGet.lodaing.value = false;
      Map map = response.data[0]['list'];

      if (map.keys.contains("10") == true) {
        appGet.batchNew.value.text = map["10"]['content'];
      }
    } catch (e) {
      appGet.lodaing.value = false;
      return null;
    }
  }
////////////////////////////////////////////////////////////////

  getCheckProducts() async {
    appGet.lodaing.value = true;
    dio = initApi();
    try {
      FormData data = FormData.fromMap({
        'auth_token': SPHelper.spHelper.getToken(),
      });
      Response response =
          await dio.post("$baseUrl" + "check-products", data: data);
      if (response.data['status'] == 401) {
        appGet.lodaing.value = false;

        setToast(response.data["massage"], color: Colors.red);
        getx.Get.off(() => SignInScreen());
      } else if (response.data['status'] == 200) {
        appGet.lodaing.value = false;
        appGet.checkProducts.assignAll(response.data['data']);
      }
      return response.data;
    } catch (e) {
      appGet.lodaing.value = false;
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////

  getSubDetailsProduct(
    int detailId,
    String orderId,
  ) async {
    appGet.lodaing.value = true;
    dio = initApi();

    try {
      FormData data = FormData.fromMap({
        'detail_id': detailId.toString(),
        'order_id': orderId.toString(),
        'auth_token': SPHelper.spHelper.getToken(),
      });

      await dio.post("$baseUrl" + "output-order", data: data);

      appGet.lodaing.value = false;
    } catch (e) {
      appGet.lodaing.value = false;
      return null;
    }
  }

////////////////////////////////////////////////////////////////

  getAllProduct() async {
    dio = initApi();
    try {
      Response response = await dio.post("$baseUrl" + "all-products", data: {
        'auth_token': SPHelper.spHelper.getToken(),
      });
      if (response.data['status'] == 401) {
        setToast(response.data["massage"], color: Colors.red);
        getx.Get.off(() => SignInScreen());
      } else if (response.data['status'] == 200) {
        appGet.allProduct.value = AllProductModel.fromJson(response.data);
      }
      return response.data;
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  getOrders() async {
    dio = initApi();
    appGet.lodaing.value = true;
    try {
      Response response = await dio.post("$baseUrl" + "orders",
          data: {'auth_token': SPHelper.spHelper.getToken()});
      appGet.lodaing.value = false;
      appGet.tokenBool.value = true;
      if (response.data['status'] == 401) {
        setToast(response.data["massage"], color: Colors.red);
        getx.Get.off(() => SignInScreen());
      } else if (response.data['status'] == 200) {
        appGet.orderModel.value = OrderModel.fromJson(response.data);
      }
    } catch (e) {
      appGet.tokenBool.value = false;
      appGet.lodaing.value = false;
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  getLogout() async {
    dio = initApi();
    appGet.lodaing.value = true;
    try {
      Response response = await dio.post("$baseUrl" + "adminLogout",
          data: {'auth_token': SPHelper.spHelper.getToken()});
    } catch (e) {
      appGet.tokenBool.value = false;

      appGet.lodaing.value = false;
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  getDetailsOrders(int orderId) async {
    dio = initApi();
    appGet.tokenBool.value = true;
    try {
      print(orderId);
      Response response = await dio.post("$baseUrl" + "order-details", data: {
        'auth_token': SPHelper.spHelper.getToken(),
        "order_id": orderId
      });
      if (response.data['status'] == 401) {
        setToast(response.data["massage"], color: Colors.red);
        getx.Get.off(() => SignInScreen());
      } else if (response.data['status'] == 200) {
        appGet.listDetailsOrders.value =
            OrderDetailsModel.fromJson(response.data["data"]);
        appGet.listDetailsOrders2.value =
            OrderDetailsModel.fromJson(response.data["data"]);
      }
    } catch (e) {
      return null;
    }
  }

  ////////////////////////////////////////////
  getSearchProduct(String barcode) async {
    initApi();
    appGet.tokenBool.value = true;
    // try {
    print(barcode);
    Response response = await dio.post("$baseUrl" + "product-data",
        data: {'auth_token': SPHelper.spHelper.getToken(), "barcode": barcode});
    if (response.data['status'] == 401) {
      setToast(response.data["massage"], color: Colors.red);
      getx.Get.off(() => SignInScreen());
      appGet.tokenBool.value = false;
    } else if (response.data['status'] == 200) {
      appGet.productModel.value =
          ProductDataModel.fromJson(response.data["data"]);
      print(response.data);
      appGet.tokenBool.value = false;
    }
    appGet.tokenBool.value = false;

    // } catch (e) {
    //   appGet.tokenBool.value = false;

    //   return null;
    // }
  }

////////////////////////////////////////////////////////////////
  getUnits() async {
    dio = initApi();
    try {
      Response response = await dio.post("$baseUrl" + "units", data: {
        'auth_token': SPHelper.spHelper.getToken(),
      });
      if (response.data['status'] == 401) {
        setToast(response.data["massage"], color: Colors.red);
        getx.Get.off(() => SignInScreen());
        appGet.tokenBool.value = false;
      } else if (response.data['status'] == 200) {
        appGet.listUnit.assignAll(response.data["data"]);
      }
      return response.data;
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  getShowVersion() async {
    dio = initApi();
    try {
      Response response = await dio.post(
        "$baseUrl" + "app-version",
      );
      // if (response.data['status'] == 401) {
      //   setToast(response.data["massage"], color: Colors.red);
      //   getx.Get.off(() => SignInScreen());
      // } else if (response.data['status'] == 200) {
      appGet.mapVersion.assignAll(response.data);
      // }
    } catch (e) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  getScanStatus() async {
    initApi();
    try {
      Response response = await dio.post("$baseUrl" + "scan-status", data: {
        'auth_token': SPHelper.spHelper.getToken(),
      });
      if (response.data['status'] == 401) {
        setToast(response.data["massage"], color: Colors.red);
        getx.Get.off(() => SignInScreen());
      } else if (response.data['status'] == 200) {
        appGet.statusModel.value = StatusModel.fromJson(response.data);
        // assignAll(response.data);
      }
      //print(response.data);
      return response.data;
    } catch (e) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  getAllUser() async {
    dio = initApi();
    try {
      Response response = await dio.post("$baseUrl" + "all-users", data: {
        'auth_token': SPHelper.spHelper.getToken(),
      });
      // if (response.data['status'] == 401) {
      //   setToast(response.data["massage"], color: Colors.red);
      //   getx.Get.off(() => SignInScreen());
      // } else if (response.data['status'] == 200) {
      appGet.listUser.assignAll(response.data);
      // }
    } catch (e) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  getUpdateWidth(
      int orderId, int detailId, int productId, String weight) async {
    dio = initApi();

    try {
      Response response = await dio.post("$baseUrl" + "update-width", data: {
        'auth_token': SPHelper.spHelper.getToken(),
        'order_id': orderId,
        'product_id': productId,
        'order_detail_id': detailId,
        'width': weight,
      });

      print(response.data);
      setToast("Done");
    } catch (e) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  getUpdateScanStatus(int id, int idStatus) async {
    initApi();
    try {
      await dio.post("$baseUrl" + "update-scan-status", data: {
        'auth_token': SPHelper.spHelper.getToken(),
        'id': id,
        'scan_status': idStatus,
      });
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  getUpdateProductBarcode(int id) async {
    dio = initApi();
    try {
      await dio.post("$baseUrl" + "update-scan-barcode", data: {
        'auth_token': SPHelper.spHelper.getToken(),
        'is_sacn_barcode': 1,
        'id': id,
      });
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  getUpdateCheck(int productId, int status, String note) async {
    dio = initApi();

    try {
      Response response = await dio.post("$baseUrl" + "update-check", data: {
        'auth_token': SPHelper.spHelper.getToken(),
        'product_id': productId,
        'status': status,
        'note': note,
      });
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
  getUpdateOrders(int id) async {
    dio = initApi();
    try {
      await dio.post("$baseUrl" + "update-order-status", data: {
        'auth_token': SPHelper.spHelper.getToken(),
        'status_id': 3,
        'id': id,
      });
      await getOrders();
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  outputOrder({
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
    int scanStatus,
    String temperature,
    String supplierNum,
    String kilo,
    String moveType,
  }) async {
    dio = initApi();

    try {
      FormData data = FormData.fromMap({
        'auth_token': SPHelper.spHelper.getToken(),
        'product_id': productId.toString(),
        'order_id': orderId.toString() ?? 0,
        'order_detail_id': orderDetailId.toString() ?? 0,
        'unit_id': unitId.toString(),
        'supplier_id': supplierNum ?? "",
        'temperature': temperature ?? "",
        'move_type': "output",
        'qty': qty,
        'barcode': barcode,
        'barcode_after_analyz': barcodeAfter,
        'production_date': pdate,
        'expiration_date': exdate,
        'name': productName,
        'stk_count': stkcount ?? "",
        'batch_num': batchNum ?? "",
        'weight': kilo ?? "",
        'scan_status': scanStatus ?? 1,
      });

      await dio.post("$baseUrl" + "store-to-warehouse", data: data);
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  getInput({
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
    String temperature,
    String supplierNum,
  }) async {
    initApi();

    try {
      FormData data = FormData.fromMap({
        'auth_token': SPHelper.spHelper.getToken(),
        'unit_id': unitId,
        // 'supplier_id': 1,
        'move_type': "input",
        'qty': qty,
        'barcode': barcode,
        'barcode_after_analyz': barcodeAfter,
        'production_date': pdate,
        'expiration_date': exdate,
        'product_name': productName,
        'stk_count': stkcount,
        'batch_num': batchNum,
        'temperature': temperature,
        'weight': kilo,
        'supplier_num': supplierNum,
      });
      Response response =
          await dio.post("$baseUrl" + "input-by-barcode", data: data);
      print(response.data);
      setToast(response.data['msg']);

      appGet.clear();
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  getLink({
    int unitId,
    String barcode,
    int productId,
  }) async {
    initApi();

    try {
      FormData data = FormData.fromMap({
        'auth_token': SPHelper.spHelper.getToken(),
        'unit_id': unitId,
        'barcode': barcode,
        'product_id': productId,
      });

      await dio.post("$baseUrl" + "link-barcode", data: data);
      setToast("Done");
      appGet.clear();
    } catch (e) {
      return null;
    }
  }

////////////////////////////////////////////////////////////////
  getCreatOrder({
    int userId,
    List<WhereHouseModel> whereHous,
  }) async {
    dio = initApi();
    String jsonhous = jsonEncode(whereHous);

    try {
      FormData data = FormData.fromMap({
        'auth_token': SPHelper.spHelper.getToken(),
        'user_id': userId,
        'shipping_id': 1,
        'delivery_date': DateTime.now().toString() ?? "",
        'warehouse': jsonhous,
      });
      Response response =
          await dio.post("$baseUrl" + "create-order", data: data);

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
