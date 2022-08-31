import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messages/controller/state_management.dart';

import '../../controller/functions.dart';
import '../../db/firebase_db.dart';
import '../../model/chat.dart';
import '../../model/user.dart';

class QuestionScreen extends StatefulWidget {
  final String idMessage;
  final UserChat userChat;
  final String groupChatId;
  QuestionScreen(
      {Key? key,
      required this.idMessage,
      required this.userChat,
      required this.groupChatId})
      : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {


  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());
    return FutureBuilder<DocumentSnapshot>(
        future:
            FirestoreDb.firebaseFirestore.collection('question').doc(controller.userId.value).get(),
        builder: (_, snapShot) {
          if(!snapShot.data!.exists) return SizedBox();
        switch(snapShot.connectionState){
          case ConnectionState.waiting:
            return Center();
          default:
            return ListView.builder(

                scrollDirection: Axis.horizontal,
                itemCount:snapShot.data!['que'].length,
                itemBuilder: (context, index) {
                  var data = snapShot.data!['que'];
                  return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      Message message = Message(
                          type: 0,
                          content: data[index],
                          time: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          idFrom: controller.userId.value,
                          idTo: widget.userChat.id,
                          isShow: false);
                      await FirestoreDb.addMessage(
                          message, widget.groupChatId);
                      Future.delayed(Duration(milliseconds: 100));
                      Message messagePeer = Message(
                          type: 0,
                          content: snapShot.data!['ans'][index],
                          time: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          idFrom: widget.userChat.id,
                          idTo: controller.userId.value,
                          isShow: false);
                      await FirestoreDb.addMessage(
                          messagePeer, widget.groupChatId);
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 3,
                      width: 90,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        snapShot.data!['que'][index],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );});
        }
        });
  }


}
