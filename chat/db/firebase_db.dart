import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:messages/controller/functions.dart';
import 'package:messages/model/addNewUser.dart';
import 'package:messages/model/notification.dart';
import 'package:messages/model/user.dart';
import '../controller/state_management.dart';
import '../model/chat.dart';
import '../utility/widget.dart';

class FirestoreDb {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static Controller get = Get.put(Controller());

  static addMessage(MessageModel message, String groupChatId) async {
    print(groupChatId);
    try {
      var documentReference = firebaseFirestore
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(message.time)
          .set(message.toJson())
          .then((value) {
        Funct.saveState(message.idTo);
        NotificationModel notification = NotificationModel(content: message.content, type: message.type.toString(), peerUserName: '', tokePeer: '');
         Funct.sendNotification(notification);
      });
    } catch (E) {
      showErrorMessage();
    }
  }

  static Stream<List<MessageModel>> messageStream(groupChatId, int lim) {
    return firebaseFirestore
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .limit(lim)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MessageModel> messages = [];
      for (var todo in query.docs) {
        final messageModel =
            MessageModel.fromDocumentSnapshot(documentSnapshot: todo);
        messages.add(messageModel);
      }
      return messages;
    });
  }

  static update(String peerId, body) {
    firebaseFirestore
        .collection('user')
        .doc(get.userId.value)
        .collection('chat')
        .doc(peerId)
        .update(body)
        .then((value) {});
  }

  static void updateShow(String id, idTo, groupChar, groupChatId) {
    try {
      if (idTo == get.userId()) {
        firebaseFirestore
            .collection('messages')
            .doc(groupChar)
            .collection(groupChatId)
            .doc(id)
            .update({
          'isShow': true,
        });
      }
    } catch (E) {
      showErrorMessage();
    }
  }

  static Future<String> initChatScreen(UserChat userChat) async {
    try {
      String id = "";
      if (userChat != null) {
        final checkUser =
            await firebaseFirestore.collection('user').doc(userChat.id).get();
        if (checkUser.exists) {
          id = userChat.id;
        } else {
          final req = await firebaseFirestore
              .collection('user')
              .doc(userChat.id)
              .set(userChat.toJson())
              .then((_) {
            id = userChat.id;
            get.userId(userChat.id);
          }).catchError((e) {
            print(e);
          });
        }
      } else {}
      return id;
    } catch (E) {
      showErrorMessage();
      return '';
    }
  }

  static void updateNewMessages(peerId) {
    print('this is peer id $peerId');
    Controller _getCon = Get.put(Controller());
    try {
      firebaseFirestore
          .collection('user')
          .doc(_getCon.userId())
          .collection('chat')
          .doc(peerId)
          .update({
        'is_new_message': false,
      });
    } catch (r) {

    }
  }

  static Future<UserChat?> checkUserExists(String id,
      NewUserAddToChatModel newUserAddToChatModel) async {
    final user = await firebaseFirestore
        .collection('user')
        .doc(id)
        .collection('chat')
        .doc(newUserAddToChatModel.id)
        .get();
    if (user.exists) {
      print(user.data().toString());
      UserChat userChat =
          UserChat.fromJson(user.data() as Map<String, dynamic>);
      return userChat;
    } else {
      UserChat? userChat = await addUserToChat(newUserAddToChatModel);
      return userChat ?? null;
    }
  }

  static Future<UserChat?> addUserToChat(
      NewUserAddToChatModel newUserAddToChatModel) async {
    try {
      Controller _getx = Get.put(Controller());
      final peer = await FirebaseFirestore.instance
          .collection('user')
          .doc(newUserAddToChatModel.id)
          .get();
      final user = await FirebaseFirestore.instance
          .collection('user')
          .doc(_getx.userId.value)
          .get();

      if (user.exists && peer.exists) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(_getx.userId.value)
            .collection('chat')
            .doc(newUserAddToChatModel.id.toString())
            .set({
          'id': peer['id'],
          'token': peer['token'],
          'block_by': '',
          'show_bot': false,
          'is_blocked': false,
          'is_provider': peer['is_provider'],
          'is_new_message': false,
          'mute': false,
          'name': peer['name'],
          'photoUrl': peer['photoUrl'],
          'idProduct': newUserAddToChatModel.idProduct,
          'imageProduct': newUserAddToChatModel.imageProduct,
          'titleProduct': newUserAddToChatModel.titleProduct,
        }).then((value) {
          FirebaseFirestore.instance
              .collection('user')
              .doc(newUserAddToChatModel.id.toString())
              .collection('chat')
              .doc(_getx.userId.value)
              .set({
            'id': user['id'],
            'token': user['token'],
            'block_by': '',
            'show_bot': false,
            'is_blocked': false,
            'is_provider': user['is_provider'],
            'is_new_message': false,
            'mute': false,
            'name': user['name'],
            'photoUrl': user['photoUrl'],
            'idProduct': newUserAddToChatModel.idProduct,
            'imageProduct': newUserAddToChatModel.imageProduct,
            'titleProduct': newUserAddToChatModel.titleProduct,
          });
        });
      } else {
        return null;
      }
      return UserChat.fromJson({
        'id': peer['id'],
        'token': peer['token'],
        'block_by': '',
        'show_bot': false,
        'is_blocked': false,
        'is_provider': peer['is_provider'],
        'is_new_message': false,
        'mute': false,
        'name': peer['name'],
        'photoUrl': peer['photoUrl'],
        'idProduct': newUserAddToChatModel.idProduct,
        'imageProduct': newUserAddToChatModel.imageProduct,
        'titleProduct': newUserAddToChatModel.titleProduct,
      });
    } catch (e) {
      showErrorMessage();
      return null;
    }
  }
}
