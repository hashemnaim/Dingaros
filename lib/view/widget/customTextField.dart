import 'package:dinengros/value/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;
  final Icon iconData;
  final int maxLine;
  final TextInputType textInputType;
  final Color fillColor;
  final String textInitialValue;
 final TextEditingController textEditingController;

  final Widget suffixIcon;
  final Widget prefixIcon;
  final bool password;

  final bool autofocus;
  final TextAlign textAlign;
  final EdgeInsetsGeometry contentPadding;

  CustomTextFormField({
    Key key,
    this.hintText,
    this.validator,
    this.onSaved,
    this.iconData,
    this.textInputType = TextInputType.text,
    this.textEditingController,
    this.textInitialValue,
    this.suffixIcon,
    this.maxLine = 1,
    this.autofocus = false,
    this.textAlign,
    this.password = false,
    this.fillColor,
    this.contentPadding,
    this.prefixIcon,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  IconData iconData = FontAwesomeIcons.eyeSlash;
  bool toggleEye = true;
  bool taped = false;
  FocusNode focusNode = FocusNode();

  fmToggleEye() {
    toggleEye = !toggleEye;
    iconData = toggleEye ? Icons.remove_red_eye : FontAwesomeIcons.eyeSlash;
    setState(() {});
  }

  @override
  void initState() {
    // focusNode.addListener(() {
    //   taped = focusNode.hasFocus;
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      style: TextStyle(
          color: AppColors.primary2,
          fontSize: 14.sp,
          fontFamily: "NunitoSans",
          fontWeight: FontWeight.w400),
      initialValue: widget.textInitialValue,
      controller: widget.textEditingController,
      autofocus: widget.autofocus,
      minLines: 1,
      maxLines: null,
      textAlign: widget.textAlign ?? TextAlign.start,
      validator: (value) => widget.validator(value),
      onSaved: (newValue) => widget.onSaved(newValue),
      onChanged: (value) {
        widget.onSaved(value);
      },
      obscureText: widget.password ? toggleEye : false,
      cursorColor: Colors.grey,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.password
            ? GestureDetector(
                child: Icon(
                  iconData,
                  color: Colors.grey,
                ),
                onTap: () {
                  fmToggleEye();
                },
              )
            : null,
        // filled: !taped,
        // fillColor: Colors.grey,
        // suffixIcon: widget.suffixIcon,
        contentPadding:
            widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w),
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.ssp,
            fontFamily: "Nunito Sans",
            letterSpacing: 1.16,
            fontWeight: FontWeight.w400),
        border: UnderlineInputBorder(
          // borderRadius: BorderRadius.circular(100.r),
          borderSide: BorderSide(
            color: AppColors.primary2,
          ),
        ),
        // focusedBorder: OutlineInputBorder(
        //   // borderRadius: BorderRadius.circular(100.r),
        //   borderSide: BorderSide(
        //     color: AppColors.primary2,
        //   ),
        // ),
        focusedErrorBorder: OutlineInputBorder(
          // borderRadius: BorderRadius.circular(100.r),
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(100.r),
        //   borderSide: BorderSide(
        //     color:  AppColors.primary2,
        //   ),
        // ),
        // errorBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(100.r),
        //   borderSide: BorderSide(
        //     color: Colors.redAccent,
        //   ),
        // ),
      ),
    );
  }
}
