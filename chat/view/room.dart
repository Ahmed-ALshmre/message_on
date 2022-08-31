import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messages/controller/functions.dart';
import 'package:messages/model/addNewUser.dart';
import 'package:messages/model/user.dart';
import 'package:messages/view/setting/setting.dart';
import 'package:messages/view/widget/Input_message.dart';
import 'package:messages/view/widget/product.dart';
import 'package:messages/view/widget/question_screen.dart';
import '../controller/state_management.dart';
import 'dart:math' as math;
import '../db/firebase_db.dart';
import '../utility/widget.dart';
import 'widget/buildListMessage.dart';

class Chat extends StatefulWidget {
  final UserChat userChat;
  Chat(
      {Key? key,
      // required this.chatProductModel,
      required this.userChat})
      : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    print(widget.userChat.id);
    FirestoreDb.updateNewMessages(widget.userChat.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.userChat.id);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color(0xff4267B2),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                photoUser(widget.userChat),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.userChat.name}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                  Text(
                    'نشط',
                    style: TextStyle(
                        color: Colors.black,
                        height: 1,
                        fontWeight: FontWeight.bold),
                  ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => SettingScreen(
                          userChat: widget.userChat,
                        ));
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Color(0xff4267B2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ChatScreen(
        userChat: widget.userChat,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final UserChat userChat;

  ChatScreen({Key? key, required this.userChat}) : super(key: key);

  @override
  State createState() => ChatScreenState(userChat: userChat);
}

class ChatScreenState extends State<ChatScreen> {
  final UserChat userChat;

  ChatScreenState({Key? key, required this.userChat});

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";

  late File imageFile;
  bool isLoading = false;
  bool cloStream = false;
  String imageUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  Controller controller = Get.put(Controller());

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      controller.chatLimit(_limit += _limitIncrement);
    }
  }

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
    readLocal(controller.userId.value);
  }



  String id = '';
  readLocal(idCo) async {
    print(idCo);
    id = idCo;
    if (id.hashCode <= widget.userChat.id.hashCode) {
      groupChatId = '$id-${widget.userChat.id}';
    } else {
      groupChatId = '${widget.userChat.id}-$id';
    }
    controller.gerobId(groupChatId);
  }
  Future<bool> onBackPress() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Obx(() {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 3,
                ),
                ProductChatScreen(newUserAddToChatModel: NewUserAddToChatModel(id: '',idProduct: widget.userChat.idProduct,titleProduct: widget.userChat.titleProduct,imageProduct: widget.userChat.imageProduct),),
                controller.uploadFileLoading.value
                    ? LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      )
                    : SizedBox(),
                groupChatId.isNotEmpty
                    ? ListOfMessage(
                        listScrollController: listScrollController,
                      )
                    : Center(
                        child: loading,
                      ),
                controller.chatIsNull.value
                    ? Container(
                        height: 50.h,
                      )
                    : SizedBox.shrink(),

               !userChat.is_provider
                    ? SizedBox()
                    : SizedBox(
                        height: 50.h,
                        child: QuestionScreen(
                          userChat: widget.userChat,
                          groupChatId: groupChatId,
                          idMessage: DateTime.now().millisecondsSinceEpoch.toString(),
                        ),
                      ),
                InputMessage(
                  groupChatId: groupChatId,
                  userChat: userChat,
                  listScrollController: listScrollController,
                ),
              ],
            );
          })
          // Loading
        ],
      ),
      onWillPop: onBackPress,
    );
  }

}
