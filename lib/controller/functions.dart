import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:messages/controller/firebase_contoller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'state_management.dart';

class Funct {
  static FirebaseFirestore _firebaseClass = FirebaseFirestore.instance;
  static Future<void> answer(var data) async {}

  static var ans = {
    'qus': '',
    'answer': 'وعليكم الاسلام',
    'key': '1',
  };

  static void onSendMessage(String content, int type, groupChatId, id, peerId) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      String _time = DateTime.now().millisecondsSinceEpoch.toString();
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(_time);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': peerId,
            'isShow': false,
            'idTo': id,
            'timestamp': _time,
            'content': content,
            'type': type,
          },
        );
      }).then((value) async {
        /*
        if (!controller.isOffline()) {
          print("this is type =>$type");
          String getToken = await Funct.getTokenPaer(peerId);
          await Funct.sendNotifOneSgn(" لقد ارسل: ${controller.nameUser.value.toString()}", [getToken], "${type == 0 ?content:""}",{'type':'1','uid':controller.userId.value.toString()},type == 1 ?  content:'');
        } else {}
        Funct.updateList(controller.userIndexChat(), peerId);
       */
      });
    } else {}
  }

  static void onSendMessage1(
      String content, int type, groupChatId, id, peerId) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      String _time = DateTime.now().millisecondsSinceEpoch.toString();
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(_time);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': peerId,
            'isShow': false,
            'idTo': id,
            'timestamp': _time,
            'content': content,
            'type': type,
          },
        );
      }).then((value) async {
        /*
        if (!controller.isOffline()) {
          print("this is type =>$type");
          String getToken = await Funct.getTokenPaer(peerId);
          await Funct.sendNotifOneSgn(" لقد ارسل: ${controller.nameUser.value.toString()}", [getToken], "${type == 0 ?content:""}",{'type':'1','uid':controller.userId.value.toString()},type == 1 ?  content:'');
        } else {}
        Funct.updateList(controller.userIndexChat(), peerId);
       */
      });
    } else {}
  }

  static Future<File> getFile(ImageSource source) async {
    File file;
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      if (image.path.isNotEmpty) {
        file = File(image.path);
      } else {
        file = File('');
      }
    } else {
      file = File('');
    }
    return file;
  }

  // show the info of the messages
  static Widget buttonShowInfo(controller, child) {
    return GestureDetector(
      onTap: () {
        if (controller.showInfo.value) {
          controller.showInfo(false);
        } else {
          controller.showInfo(true);
        }
        // this is long press
      },
      child: child,
    );
  }

  static void updateNewMessages(peerId) {
    Controller _getCon = Get.put(Controller());
    try {
      FirebaseFirestore.instance
          .collection('user')
          .doc(_getCon.userId())
          .collection('chat')
          .doc(peerId)
          .update({
        'neMess': false,
      });
    } catch (r) {}
  }

  static void updateList(String id) async {
    Controller _get = Get.put(Controller());
    _firebaseClass
        .collection('user')
        .doc(_get.userId())
        .collection('chat')
        .doc(id)
        .update({
      'time': DateTime.now(),
    }).then((_) async {
      print(id);
      await _firebaseClass
          .collection('user')
          .doc(id)
          .collection('chat')
          .doc(_get.userId())
          .update({
        'time': DateTime.now(),
        'is_new_message': true,
      });
    }).then((value) {});
  }

  static Future<void> setStatus(String status, id) async {
    Controller controller = Get.put(Controller());
    await FirebaseFirestore.instance.collection('user').doc(id).update({
      "status": status,
    });
    controller.status(status == "Online" ? true : false);
  }

  static String convertTimerToDataTime(String date) {
    int _date = int.parse(date);
    var dt = DateTime.fromMillisecondsSinceEpoch(_date);
    var timeH = DateFormat('HH:mm').format(dt);

    return timeH.toString();
  }

  static List<String> getListId() {
    MessageController messageController = Get.put(MessageController());
    List<String> idMessage = [];
    for (int i = 0; i < messageController.messages.length; i++) {
      print(messageController.messages[i].content);
      String idSing = messageController.messages[i].time;
      idMessage.add(idSing);
    }
    return idMessage;
  }

  static Future<void> saveState(String id) async {
    Controller controller = Get.put(Controller());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isUserExists = prefs.getBool('id') ?? false;
    if (isUserExists) {
      controller.isUserExists(true);
    } else {
      prefs.setBool(id, true);
      controller.isUserExists(false);
    }
  }

  Widget timeAndSee(String time, bool isShow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isShow
            ? Image.asset(
          'assets/icon/check_double.png',
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
