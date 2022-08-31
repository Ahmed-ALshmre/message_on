import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/firebase_contoller.dart';
import 'bubbles.dart';

class ListOfMessage extends StatelessWidget {
  final ScrollController listScrollController;
  const ListOfMessage({Key? key, required this.listScrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: GetX<MessageController>(
            init: Get.put<MessageController>(MessageController()),
            builder: (MessageController messageController) {

              if (messageController.messages.isNotEmpty) {
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 8),
                  itemBuilder: (context, index) {
                    return Bubbles(
                      message: messageController.messages[index],
                    );
                  },
                  itemCount: messageController.messages.length,
                  reverse: true,
                  controller: listScrollController,
                );
              } else {
                return Center(child: Text('لا يوجد رسال'),);
              }
            }));
  }
}
