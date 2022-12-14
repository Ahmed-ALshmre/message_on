import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:messages/controller/firebase_contoller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/notification.dart';
import 'state_management.dart';

class Funct {
  static FirebaseFirestore _firebaseClass = FirebaseFirestore.instance;
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

  static String convertTimerToDataTime(String date) {
    int _date = int.parse(date);
    var dt = DateTime.fromMillisecondsSinceEpoch(_date);
    var timeH = DateFormat('HH:mm').format(dt);

    return timeH.toString();
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

  static void sendNotification(NotificationModel notification)  {
    // send notification
  }
}
