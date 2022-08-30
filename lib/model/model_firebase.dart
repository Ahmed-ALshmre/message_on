import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? documentId;
  late String content;
  late Timestamp createdOn;
  late bool isDone;

  TodoModel({
    required this.content,
    required this.isDone,
//     required this.createdOn,
  });

  TodoModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    documentId = documentSnapshot.id;
    content = documentSnapshot["content"];
    isDone = documentSnapshot["isDone"];
  }
}