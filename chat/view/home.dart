import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messages/view/room.dart';
import '../controller/functions.dart';
import '../controller/state_management.dart';
import '../db/firebase_db.dart';
import '../model/user.dart';
import '../utility/widget.dart';

class ChatHomeScreen extends StatefulWidget {
  final String currentUserId;
  const ChatHomeScreen({Key? key, required this.currentUserId})
      : super(key: key);
  @override

  ///
  State createState() => ChatHomeScreenState(currentUserId: currentUserId);
}

class ChatHomeScreenState extends State<ChatHomeScreen> {
  ChatHomeScreenState({Key? key, required this.currentUserId});
  String currentUserId;

  bool isLodiing = true;

  static final Controller controller = Get.put(Controller());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.isDarkMode;

    return Scaffold(
      backgroundColor: theme ? Colors.black : Colors.white,
      body: currentUserId.isEmpty
          ? Center(
              child: loading,
            )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10).r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "المحادثة",
                        style: TextStyle(
                            fontSize: 32.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16).r,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "ابحث...",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Colors.grey.shade100)),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirestoreDb.firebaseFirestore
                          .collection('user')
                          .doc(currentUserId)
                          .collection('chat')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return Text('لقد حدث خطا تاكد من اتصالك بالنترنيت');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return loading;
                          default:
                            return snapshot.data!.docs.length == 0
                                ? Center(
                                    child: Text(
                                      'لا توجد محادثات',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      UserChat userChat = UserChat.fromJson(
                                          snapshot.data!.docs[index].data()
                                              as Map<String, dynamic>);
                                      return InkWell(
                                          onTap: () {
                                            Funct.saveState(userChat.id);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Chat(
                                                  userChat: userChat,
                                                ),
                                              ),
                                            );
                                          },
                                          child: ConversationList(
                                            userChat: userChat,
                                          ));
                                    });
                        }
                      }),
                ),
              )
            ],
          ),
    );
  }
}

class ConversationList extends StatefulWidget {
  final UserChat userChat;
  ConversationList({required this.userChat});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                photoUser(widget.userChat),
                sizedBoxW(16),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.userChat.name,
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        sizedBoxH(6),
                        widget.userChat.titleProduct!.isNotEmpty
                            ? Text(
                                widget.userChat.titleProduct!,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.normal),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          widget.userChat.is_new_message
              ? Container(
                  height: 15.h,
                  width: 15.w,
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent.shade700,
                    shape: BoxShape.circle,
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
