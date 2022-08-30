
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:messages/controller/state_management.dart';

import 'package:messages/view/home.dart';


class TestScreen extends StatelessWidget {
  TestScreen({Key? key}) : super(key: key);
  final Controller controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                controller.userId('PXr5Qq59l5XBdhWJuxom');

                Get.to(() => ChatHomeScreen(
                      currentUserId: 'PXr5Qq59l5XBdhWJuxom',
                    ));
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.purple,
                height: 100,
                width: double.infinity,
                child: Text('User 1'),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(8.0).r,
            child: InkWell(
              onTap: () async {


                controller.userId('93953232');
                Get.to(() => ChatHomeScreen(currentUserId: '93953232'));
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.red,
                height: 100,
                width: double.infinity,
                child: Text('User 2'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
