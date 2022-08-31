import 'package:flutter/cupertino.dart';
import 'package:messages/controller/functions.dart';

class WidgetChat {
 static Widget timeAndSee(String time, bool isShow) {
   print(isShow);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(Funct.convertTimerToDataTime(time)),
        isShow
            ? Image.asset(
          'assets/check_double.png',
          height: 15,
          width: 15,
          fit: BoxFit.cover,
        )
            : Icon(
          CupertinoIcons.check_mark,
          size: 15,
        ),
      ],
    );
  }
}