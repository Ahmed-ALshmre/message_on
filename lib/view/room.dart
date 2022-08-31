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

class _ChatState extends State<Chat> with WidgetsBindingObserver {
  @override
  Controller _controller = Get.put(Controller());
  void initState() {
    updateNewMessages();
    WidgetsBinding.instance.addObserver(this);
    Funct.setStatus("نشط", _controller.userId.value);
    super.initState();
  }

  void updateNewMessages() {
    Controller _getCon = Get.put(Controller());
    try {
      FirebaseFirestore.instance
          .collection('user')
          .doc(_getCon.userId())
          .collection('chat')
          .doc(widget.userChat.id)
          .update({
        'is_new_message': false,
      });
    } catch (r) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      Funct.setStatus("نشط", _controller.userId.value);
    } else {
      // offline
      Funct.setStatus("غير نشط", _controller.userId.value);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Funct.setStatus("غير نشط", _controller.userId.value);
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
                Hero(
                  tag: widget.userChat.id,
                  child: widget.userChat.photoUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.userChat.photoUrl.toString(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 40.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            height: 40.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      : Container(
                          height: 40.h,
                          width: 40.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade500),
                          child: Text(
                            widget.userChat.name.toString()[0],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                ),
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
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('user')
                              .where('id', isEqualTo: widget.userChat.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return SizedBox();
                              default:
                                return Text(
                                  snapshot.data!.docs[0]['status'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      height: 1,
                                      fontWeight: FontWeight.bold),
                                );
                            }
                          }),
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
    id = idCo;
    if (id.hashCode <= widget.userChat.id.hashCode) {
      groupChatId = '$id-${widget.userChat.id}';
    } else {
      groupChatId = '${widget.userChat.id}-$id';
    }
    controller.gerobId(groupChatId);
  }
  Future<bool> onBackPress() {
    if (!cloStream) {
      setState(() {
        cloStream = true;
      });
    } else {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Navigator.pop(context);
    }

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
                        child: CircularProgressIndicator(),
                      ),
                controller.chatIsNull.value
                    ? Container(
                        height: 50,
                      )
                    : SizedBox.shrink(),

               !userChat.is_provider
                    ? SizedBox()
                    : SizedBox(
                        height: 50,
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
