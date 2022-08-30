import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String documentId;
  late int type;
  late String content;
  late String time;
  late bool isShow;
  late String idFrom;
  late String idTo;

  Message({
    required this.type,
    required this.content,
    required this.time,
    required this.idFrom,
    required this.idTo,
    required this.isShow,
  });
  Message.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    documentId = documentSnapshot.id;
    content = documentSnapshot["content"];
    idFrom = documentSnapshot['idFrom'];
    isShow = documentSnapshot['isShow'];
    time = documentSnapshot['timestamp'];
    idTo = documentSnapshot['idTo'];
    type = documentSnapshot['type'];
  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> _d = Map<String,dynamic>();
    _d['content'] = this.content;
    _d['idFrom'] = this.idFrom;
    _d['isShow'] = this.isShow;
    _d['timestamp'] = this.time;
    _d['idTo'] = this.idTo;
    _d['type'] = this.type;
    return _d;
  }
}
