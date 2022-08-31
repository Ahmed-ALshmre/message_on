import 'package:get/get.dart';
import 'package:messages/controller/state_management.dart';
import '../db/firebase_db.dart';
import '../model/chat.dart';

class MessageController extends GetxController {
  RxString geopid = ''.obs;
  Rx<List<MessageModel>> MessageList = Rx<List<MessageModel>>([]);
  List<MessageModel> get messages => MessageList.value;

  @override
  void onReady() {
    Controller controller = Get.put(Controller());
    MessageList.bindStream(FirestoreDb.messageStream(controller.gerobId.value,controller.chatLimit.value));
  }
}
