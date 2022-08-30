import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messages/controller/state_management.dart';
import 'package:messages/model/user.dart';
import '../../db/firebase_db.dart';

class SettingScreen extends StatefulWidget {
  final UserChat userChat;

  SettingScreen({Key? key, required this.userChat}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool not = false;
  Controller controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'الاعدادات',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(controller.userId.value)
              .collection('chat')
              .where('id', isEqualTo: widget.userChat.id)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: SizedBox());
              default:
                return Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Hero(
                            tag: widget.userChat.id,
                            child: widget.userChat.photoUrl!.isNotEmpty ?  CachedNetworkImage(
                              imageUrl: widget.userChat.photoUrl.toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ):Container(
                              height: 50.h,
                              width: 50.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey.shade500),
                              child:  Text(widget.userChat.name.toString()[0],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.userChat.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                    block(snapshot.data!.docs[0]),
                  ],
                );
            }
          }),
    );
  }

  Widget block(var data) {
    if (widget.userChat.is_blocked) {
      return controller.userId.value == data['block_by']
          ? Column(
              children: [
                ListTile(
                  title: Text('حظر'),
                  leading: Icon(Icons.block),
                  trailing: Switch(
                    value: widget.userChat.is_blocked,
                    onChanged: (v) {
                      setState(() {
                        FirestoreDb.update(widget.userChat.id, {
                          'is_blocked': v,
                          'block_by': controller.userId.value,
                        });
                        controller.is_block(v ? true : false);
                        widget.userChat.is_blocked = v;
                        print(v);
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('الاشعارات'),
                  leading: Icon(CupertinoIcons.bell_solid),
                  trailing: Switch(
                    value:data['mute'] ,
                    onChanged: (v) {
                      setState(() {
                        FirestoreDb.update(widget.userChat.id, {
                          'mute': v,

                        });

                      });
                    },
                  ),
                ),
              ],
            )
          : SizedBox();
    } else {
      return Column(
        children: [
          ListTile(
            title: Text('حظر'),
            leading: Icon(Icons.block),
            trailing: Switch(
              value: widget.userChat.is_blocked,
              onChanged: (v) {
                setState(() {
                  FirestoreDb.update(widget.userChat.id, {
                    'is_blocked': v,
                    'block_by': controller.userId.value,
                  });
                  controller.is_block(v ? true : false);
                  widget.userChat.is_blocked = v;
                  print(v);
                });
              },
            ),
          ),
          ListTile(
            title: Text('الاشعارات'),
            leading: Icon(CupertinoIcons.bell_solid),
            trailing: Switch(
              value: data['mute'],
              onChanged: (v) {
                setState(() {
                  FirestoreDb.update(widget.userChat.id, {
                    'mute': v,

                  });
                });
              },
            ),
          ),
        ],
      );
    }
  }
}
