import 'package:dinengros/value/colors.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ProgressDialogUtils extends ProgressDialog {
  static ProgressDialog pr;

  ProgressDialogUtils(BuildContext context) : super(context);

  static ProgressDialog createProgressDialog(BuildContext context) {
    pr = pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: 'Please Wait',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressTextStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 13.0,
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.normal),
    );
    return pr;
  }

  void showProgressDialog() {
    if (pr != null) {
      pr.show();
    }
  }

  void hideProgressDialog() {
    if (pr != null) {
      pr.hide();
    }
  }
}
