import 'package:dinengros/Controller/api/api.dart';
import 'package:dinengros/view/screen/main_screen/home_screen.dart';
import 'package:dinengros/view/widget/background.dart';
import 'package:dinengros/view/widget/customTextField.dart';
import 'package:dinengros/view/widget/custom_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInScreen extends StatelessWidget {
  GlobalKey<FormState> signKey = GlobalKey<FormState>();
  String email;
  String password;

  setEmail(String email) {
    this.email = email;
  }

  setPassword(String password) {
    this.password = password;
  }

  validationEmail(String data) {
    if (data == null || data == '') {
      return 'must be filled';
    }
    // else if (!GetUtils.isEmail(data)) {
    //   return 'الايميل غير مناسب';
    // }
  }

  validationNull(String data) {
    if (data == null || data == '') {
      return ' must be filled';
    }
  }

  validationString(String data) {
    if (data == null || data == '') {
      return ' must be filled';
    }
    //else if (data.length < 8) {
    //   return 'يجب ان يكون اكثر من 8 خانات';
    // }
  }

  saveForm() async {
    if (signKey.currentState.validate()) {
      signKey.currentState.save();

      await ApiServer.instance.signInServer(
        email: email,
        password: password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Background(
          logo: true,
          contant: Form(
            key: signKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextFormField(
                    hintText: 'Brukernavn',
                    // prefixIcon: Padding(
                    //   padding: EdgeInsets.only(left: 16.w),
                    //   child: Icon(
                    //     Icons.person,
                    //     size: 20.r,
                    //   ),
                    // ),
                    validator: validationNull,
                    onSaved: setEmail,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextFormField(
                    // password: true,
                    hintText: 'Passord',
                    // prefixIcon: Padding(
                    //   padding: EdgeInsets.only(left: 16.w),
                    // child: Icon(
                    //   Icons.lock,
                    //   size: 20.r,
                    // ),
                    // ),/
                    validator: validationNull,
                    onSaved: setPassword,
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CustomButton(
                        text: 'Logg inn',
                        padding: EdgeInsets.zero,
                        onTap: saveForm),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
