import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign textAlign;
  final Color color;
  final bool underline;
  final FontWeight fontWeight;
  final int maxLines;
  final double letterSpacing;
  final String fontFamily;
  final TextStyle style;

  CustomText(
    this.text, {
    this.fontSize,
    this.textAlign,
    this.color,
    this.fontWeight,
    this.underline = false,
    this.maxLines,
    this.fontFamily,
    this.letterSpacing,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text ?? '',
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
        style: GoogleFonts.montserrat(
          color: color ?? Colors.black,
          decoration:
              underline ? TextDecoration.underline : TextDecoration.none,
          fontSize: fontSize ?? 20.sp,
          fontWeight: fontWeight ?? FontWeight.w500,
        )
        // style??TextStyle(
        //   fontWeight: fontWeight ?? FontWeight.w500,
        //   fontSize: fontSize ?? 20.sp,
        //   color: color ?? Colors.black,
        //   fontFamily: fontFamily ?? "Manrope",
        //   decoration: underline ? TextDecoration.underline : TextDecoration.none,
        //   letterSpacing: letterSpacing != null
        //       ? letterSpacing
        //       : fontFamily == 'NunitoSans'
        //           ? 0.168
        //           : 0,
        // ),

        );
  }
}
