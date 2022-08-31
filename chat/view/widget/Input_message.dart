import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messages/controller/state_management.dart';
import 'package:messages/model/user.dart';
import '../../aude/adue.dart';
import '../../controller/functions.dart';
import '../../db/firebase_db.dart';
import '../../model/chat.dart';
import '../../utility/theme.dart';

class InputMessage extends StatefulWidget {
  final UserChat userChat;
  final ScrollController listScrollController;
  final String groupChatId;
  InputMessage(
      {Key? key,
      required this.userChat,
      required this.listScrollController,
      required this.groupChatId})
      : super(key: key);

  @override
  State<InputMessage> createState() => _InputMessageState();
}

class _InputMessageState extends State<InputMessage> {
  FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    SystemChannels.textInput.invokeMethod('TextInput.show');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());
    return Obx(() {
      if (controller.is_block.value) {
        return Container(
          height: 40,
          child: Text(
            ' تم حظرك لا يمكن رسال رساله',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      } else {
        return getBottom(controller);
      }
    });
  }

  Widget getBottom(Controller controller) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(color: grey.withOpacity(0.2)),
      child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 10, bottom: 10),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      !controller.sendMessageButtomn.value
                          ? InkWell(
                              onTap: () async {
                                Message message = Message(
                                    type: 6,
                                    content: '',
                                    time: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    idFrom: controller.userId.value,
                                    idTo: widget.userChat.id,
                                    isShow: false);
                                onSendMessage(controller, message, widget.groupChatId);
                              },
                              child:  Icon(
                                Icons.thumb_up,
                                size:controller.recording.value ? 0:35 ,
                                color: Color(0xff4267B2),
                              ),
                            )
                          : InkWell(
                              onTap: () async {
                                if (controller.sizeTextFild.value > 230) {
                                  Message message = Message(
                                      type: 0,
                                      content: textEditingController.text,
                                      time: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      idFrom: controller.userId.value,
                                      idTo: widget.userChat.id,
                                      isShow: false);
                                  if (textEditingController.text.isNotEmpty) {
                                    onSendMessage(controller, message,
                                        widget.groupChatId);
                                    textEditingController.text = '';
                                    controller.sendMessageButtomn(false);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'لا يوجد رسالة');
                                  }
                                } else if (controller
                                    .filePathChat.value.isNotEmpty) {
                                } else {}
                              },
                              child: Image.asset(
                                'assets/send.png',
                                height: 35,
                              ),
                            ),
                      SizedBox(
                        width: 15,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 320),
                        width: !controller.recording.value
                            ?  controller.sendMessageButtomn.value ? controller.sizeTextFild.value:200
                            : 230,
                        decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(20)),
                        child: controller.recording.value
                            ? RecordInput(controller)
                            : Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: TextField(
                                  focusNode: focusNode,
                                  onTap: (){
                                    focusNode.requestFocus();
                                  },
                                  minLines: 1,
                                  maxLines: 5,
                                  controller: textEditingController,
                                  onChanged: (v) {
                                    controller.sendMessageButtomn(
                                        v.length == 0 ? false : true);
                                    if (v.length > 0) {
                                      controller.sizeTextFild(280);
                                    } else {
                                      controller.sizeTextFild(200);
                                    }
                                  },
                                  cursorColor: black,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "ادخل الرسالة",
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment.center,
                  duration: Duration(
                      milliseconds:
                          controller.sizeTextFild.value >= 220 ? 1 : 800),
                  width:  !controller.sendMessageButtomn.value ? 100.w : 40.w,
                  child:!controller.sendMessageButtomn.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            !controller.recording.value
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        fileMessage(
                                          ImageSource.camera,
                                          controller,
                                        );
                                      },
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 30.sp,
                                        color: Color(0xff4267B2),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              width: 5.w,
                            ),
                            !controller.recording.value
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        fileMessage(
                                          ImageSource.gallery,
                                          controller,
                                        );
                                      },
                                      child: Icon(
                                        Icons.photo,
                                        size: 30.sp,
                                        color: Color(0xff4267B2),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            Expanded(
                              child: Recorder(
                                idFrom: controller.userId.value,
                                idTo: widget.userChat.id,
                                gr: widget.groupChatId.toString(),
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () async {
                            fileMessage(
                              ImageSource.gallery,
                              controller,
                            );
                          },
                          child: Icon(
                            Icons.attach_file_sharp,
                            size: 30,
                            color: Color(0xff4267B2),
                          )),
                ),
              ],
            ),
          )),
    );
  }

  void onSendMessage(controller, message, groupChatId) async {
    await FirestoreDb.addMessage(message, groupChatId);
    textEditingController.text = '';
    widget.listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 50), curve: Curves.easeOut);
    // send notif
    Funct.updateList(widget.userChat.id);
  }

  void fileMessage(ImageSource source, Controller controller) async {
    final file = await Funct.getFile(source);
    String urlImage = ""; // here the funct to uploade file
    Message message = Message(
        type: 0,
        content: urlImage,
        time: DateTime.now().millisecondsSinceEpoch.toString(),
        idFrom: controller.userId.value,
        idTo: widget.userChat.id,
        isShow: false);
    if (urlImage.isNotEmpty) {
      onSendMessage(controller, message, widget.groupChatId);
      Funct.updateList(widget.userChat.id);
    } else {
      Fluttertoast.showToast(msg: 'لا يوجد ملف');
    }
  }

  Widget RecordInput(Controller controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(controller.recTime.value),
    );
  }
}
