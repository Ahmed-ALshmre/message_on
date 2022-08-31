import 'package:flutter/material.dart';
import 'package:get/get.dart';


Widget get loading => const Center(child: CircularProgressIndicator(),);

void showErrorMessage(){
  Get.showSnackbar(GetSnackBar(message: "لقد حدث خطا تاكد من اتصالك بالشبكة",title: "لقد حدث خطا",duration: Duration(milliseconds: 1000),));
}