import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

setToast(String msg,{Color color=Colors.green,}) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
  TextStyle style = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );