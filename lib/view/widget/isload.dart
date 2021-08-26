import 'package:dinengros/value/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class IsLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
                SpinKitWanderingCubes(
  color: AppColors.primary,
  size: 20.0,
);
    
    // Container(
    //   child: CircleAvatar(
    //     backgroundColor: Colors.transparent,
    //     radius: 30,
    //     child: CircularProgressIndicator(
    //       backgroundColor: Colors.transparent,
    //       valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
    //       strokeWidth: 2.5,
    //     ),
    //   ),
    // );
  }
}
