 import 'package:dinengros/value/colors.dart';
import 'package:flutter/material.dart';

// import 'package:youth_councils/value/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;

  CustomButton({
    this.text,
    this.onTap,
    this.height,
    this.width, this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,

      padding: padding??EdgeInsets.symmetric(horizontal: 16.w),
      child: FlatButton(
        onPressed: onTap ?? () => print('kkk'),
        splashColor: AppColors.primary.withOpacity(0.5),
        color: AppColors.primary2,
        padding: EdgeInsets.zero,
        height: height ?? 54.h,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
         ),
        child: Text(
          text?? '',
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "Manrope",
              color: Colors.white),
        ),
      ),
    );
  }
}
