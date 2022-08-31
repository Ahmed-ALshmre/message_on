import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messages/model/user.dart';

Widget get loading => const Center(
      child: CircularProgressIndicator(),
    );

void showErrorMessage() {
  Get.showSnackbar(GetSnackBar(
    message: "لقد حدث خطا تاكد من اتصالك بالشبكة",
    title: "لقد حدث خطا",
    duration: Duration(milliseconds: 1000),
  ));
}

TextStyle get textStyle =>
    TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black);

Widget photoUser(UserChat userChat) {
  return Hero(
    tag: userChat.id.toString(),
    child: userChat.photoUrl!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: userChat.photoUrl!,
            imageBuilder: (context, imageProvider) => Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade200),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        : Container(
            height: 50.h,
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.shade500),
            child: Text(
              userChat.name.toString()[0],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
  );
}

Widget  sizedBoxH(double hi) => SizedBox(height:hi.h,);
Widget  sizedBoxW(double w) => SizedBox(width:w.w,);


