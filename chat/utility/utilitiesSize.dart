import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UtilitiesSize {
  static double fullScreenWidth(context) => MediaQuery.of(context).size.width;
  static double fullScreenHeight(context) => MediaQuery.of(context).size.height;
  static double sizeWidth(double size) => ScreenUtil().setWidth(size);
  static double sizeHeight(double size) => ScreenUtil().setHeight(size);
  static double size10h = 10.h;
  static double size10w = 10.w;
  static double size20 = 20.h;
  static double size30 = 30.h;
  static double size40 = 40.h;
  static double fontSize10(double size) => size.sp;
}
