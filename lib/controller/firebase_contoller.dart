import 'package:get/get.dart';
import 'package:messages/controller/state_management.dart';
import '../db/firebase_db.dart';
import '../model/chat.dart';

class MessageController extends GetxController {
  RxString geopid = ''.obs;
  Rx<List<Message>> MessageList = Rx<List<Message>>([]);
  List<Message> get messages => MessageList.value;

  @override
  void onReady() {
    Controller controller = Get.put(Controller());
    MessageList.bindStream(FirestoreDb.messageStream(controller.gerobId.value,controller.chatLimit.value));
  }
}