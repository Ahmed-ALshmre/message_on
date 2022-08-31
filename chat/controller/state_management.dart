import 'package:get/get.dart';

class Controller extends GetxController {
  RxString userId = ''.obs;
  RxBool send_chat = false.obs;
  RxDouble sizeTextFild = 200.0.obs;
  RxString filePathChat = "".obs;
  RxString gerobId = "".obs;
  RxBool showInfo = false.obs;
  RxBool chatIsNull = false.obs;
  RxBool uploadFileLoading = false.obs;
  RxBool status = false.obs;
  RxBool is_block = false.obs;
  RxBool show_bot = false.obs;
  RxBool sendMessageButtomn = false.obs;
  RxString recTime ="".obs;
  RxBool isLoadingFile = false.obs;
  RxBool recording = false.obs;
  RxInt chatLimit = 30.obs;
  RxBool isUserExists = false.obs;
  RxBool cloStream = false.obs;

}