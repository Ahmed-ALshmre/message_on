import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messages/view/room.dart';
import '../controller/functions.dart';
import '../controller/state_management.dart';
import '../model/user.dart';

import '../utility/widget.dart';

class ChatHomeScreen extends StatefulWidget {
  final String currentUserId;
  const ChatHomeScreen({Key? key, required this.currentUserId}) : super(key: key);
  @override

  ///
  State createState() => ChatHomeScreenState(currentUserId: currentUserId);
}

class ChatHomeScreenState extends State<ChatHomeScreen> {
  ChatHomeScreenState({Key? key, required this.currentUserId});
   String currentUserId ;

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
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "المحادثة",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
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
                  Container(
                    height: 400,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('user')
                            .doc(currentUserId)
                            .collection('chat')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return const Text(
                                'لقد حدث خطا تاكد من اتصالك بالنترنيت');
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
                                              peerId: userChat.id,
                                              imageUrl: userChat.photoUrl!,
                                              isMessageRead:
                                                  userChat.is_new_message,
                                              messageText:
                                                  userChat.titleProduct.toString(),
                                              name: userChat.name,
                                              is_new_message:
                                                  userChat.is_new_message,
                                            ));
                                      });
                          }
                        }),
                  )
                ],
              ),
            ),
    );
  }
}

class ConversationList extends StatefulWidget {
  String name;
  String messageText;
  String imageUrl;
  bool is_new_message;
  bool isMessageRead;
  String peerId;
  ConversationList(
      {required this.peerId,
      required this.name,
      required this.messageText,
      required this.imageUrl,
      required this.is_new_message,
      required this.isMessageRead});
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
                Hero(
                  tag: widget.peerId.toString(),
                  child: widget.imageUrl.isNotEmpty ? CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade200),
                    ),

                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ):Container(
                    height: 50.h,
                    width: 50.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey.shade500),
                  child:  Text(widget.name.toString()[0],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.name,
                          style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        widget.messageText.isNotEmpty ?  Text(
                          widget.messageText,
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey.shade600,
                              fontWeight: widget.isMessageRead
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ):SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          widget.is_new_message
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
