import 'dart:async';
import 'dart:io' as io;

import 'package:file/file.dart';
import 'package:file/local.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messages/controller/state_management.dart';
import 'package:messages/model/chat.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import '../controller/upload.dart';
import '../db/firebase_db.dart';
import '../utility/widget.dart';

class Recorder extends StatefulWidget {
  final String? idTo;
  final String? idFrom;
  final String? gr;
  final LocalFileSystem localFileSystem;
  Recorder({localFileSystem, this.idTo, this.idFrom, this.gr})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new RecorderState();
}

class RecorderState extends State<Recorder> {
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  Controller _controller = Get.put(Controller());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => GestureDetector(
            child: InkWell(
              child: _controller.recording.value
                  ? Container(
                      alignment: Alignment.center,
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Icon(
                        CupertinoIcons.mic,
                        size: 30,
                        color: Color(0xff4267B2),
                      ))
                  : Container(
                      alignment: Alignment.center,
                      child: Icon(
                        CupertinoIcons.mic,
                        size: 30,
                        color: Color(0xff4267B2),
                      )),
              onTap: () {
                SystemChannels.textInput.invokeMethod('TextInput.show');
                Fluttertoast.showToast(msg: "اضغط مطول");
              },
            ),
            onLongPressStart: (_) async {
              SystemChannels.textInput.invokeMethod('TextInput.show');
              _controller.recording(true);
              _start();
              isPressed = true;
              do {
                print('long pressing'); // for testing
                await Future.delayed(Duration(seconds: 1));
              } while (isPressed);
            },
            onLongPressEnd: (_) {
              setState(() => isPressed = false);
              print('/////////_stop////////');
              _controller.recording(false);
              _stop();
            })));
  }

  _init() async {
    try {
      bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;
      if (hasPermission) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;

        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();
        print(customPath);

        _recorder = FlutterAudioRecorder2(
          customPath,
          audioFormat: AudioFormat.AAC,
        );
        await _recorder!.initialized;
        // after initialization
        var current = await _recorder!.current(channel: 0);
        print(current);

        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          print(_currentStatus);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder!.start();
      var recording = await _recorder!.current(channel: 0);
      setState(() {
        _current = recording;
      });
      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }
        var current = await _recorder!.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
        print(_current?.duration.toString());
        _controller.recTime(_current?.duration.toString());
      });
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    try {
      _controller.uploadFileLoading(true);
      print('start close ');
      var result = await _recorder!.stop();

      File file = widget.localFileSystem.file(result!.path);

      if (_current?.duration!.inSeconds.toInt() != 0) {
        String url = await UploadFile.serverFile(file, UploadFile.voiceRoute);
        if(url.isNotEmpty){
          _controller.uploadFileLoading(true);
          onSendMessage(url);
        }else{
          showErrorMessage();
        }
      } else {}

      setState(() {
        _current = result;
        _currentStatus = _current!.status!;
      });
      _controller.recTime('');
      _init();
      _controller.uploadFileLoading(false);
    } catch (e) {
      print(e);
    }
  }

  Future<void> onSendMessage(String url) async {
    FirestoreDb.addMessage(
        MessageModel(
            type: 7,
            content: url,
            time: DateTime.now().millisecondsSinceEpoch.toString(),
            idFrom: widget.idFrom.toString(),
            idTo: widget.idTo.toString(),
            isShow: false),
        widget.gr.toString());
  }
}
