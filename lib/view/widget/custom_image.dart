import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPngImage extends StatelessWidget {
  final String imageName;
  final double height;
  final double width;
  final Color color;
  final BoxFit fit;

  CustomPngImage(
      {this.imageName, this.height, this.width, this.color, this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$imageName.png',
      height: height ?? 30.h,
      width: width ?? 30.w,
      fit: fit ?? BoxFit.fill,
      color: color,
    );
  }
}

class CustomSvgImage extends StatelessWidget {
  final String imageName;
  final double height;
  final double width;
  final Color color;
  final BoxFit fit;

  CustomSvgImage({
    this.imageName,
    this.height,
    this.width,
    this.color,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/$imageName.svg',
       height: height ?? 103.h,
      width: width ?? 30.w,
      fit: fit,
      color: color,
    );
  }
}

class CustomLogo extends StatelessWidget {
  final double height;
  final double width;

  CustomLogo({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "logo",
      child: CustomPngImage(
        imageName: "logo",
        width: width ?? 190.w,
        height: height ?? 190.h,
        fit: BoxFit.contain,
      ),
    );
  }
}


