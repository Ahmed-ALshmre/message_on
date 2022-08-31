

class NotificationModel {
  late String content;
  late String peerUserName;
  late String type;
  late String tokePeer;

  NotificationModel({
    required this.content,
    required this.type,
    required this.peerUserName,
    required this.tokePeer,
  });
}
