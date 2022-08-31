import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:messages/controller/state_management.dart';
import 'package:messages/model/chat.dart';
import 'package:flutter/material.dart';
import 'package:messages/view/widget/widget_message.dart';

import 'dart:math' as math;
import '../../controller/functions.dart';
import '../../utility/theme.dart';
import '../../utility/utilitiesSize.dart';
import 'full_image.dart';

class Bubbles extends StatefulWidget {
  final Message message;
  Bubbles({Key? key, required this.message}) : super(key: key);

  @override
  State<Bubbles> createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles> {
  AudioPlayer player = AudioPlayer();
  bool isPlay = false;
  Duration duration = Duration.zero;
  Duration pos = Duration.zero;
  @override
  void initState() {
    player.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlay = event == PlayerState.PLAYING;
      });
    });
    player.onDurationChanged.listen((newD) {
      duration = newD;
    });
    player.onAudioPositionChanged.listen((newPos) {
      setState(() {
        pos = newPos;
      });
    });
    player.onPlayerCompletion.listen((event) {
      setState(() {
        duration = Duration.zero;
        pos = Duration.zero;
      });
    });
    super.initState();
  }

  bool clack = false;
  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());
    if (widget.message != null) {
      if (widget.message.idFrom == controller.userId.value) {
        return Row(
          children: <Widget>[
            widget.message.type == 0
                ? Flexible(
                    child: InkWell(
                        onLongPress: () {
                          //'this is long press'
                        },
                        child: Funct.buttonShowInfo(
                            controller,
                            Obx(
                              () => Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  AnimatedOpacity(
                                    duration: Duration(
                                      milliseconds: 200,
                                    ),
                                    opacity: controller.showInfo.value ? 1 : 0,
                                    child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        height: 20,
                                        width: 60,
                                        alignment: Alignment.center,
                                        child: WidgetChat.timeAndSee(
                                            widget.message.time,
                                            widget.message.isShow)),
                                  ),
                                  AnimatedPadding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            controller.showInfo.value ? 25 : 0),
                                    duration: Duration(milliseconds: 300),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          right: 50,
                                          bottom:
                                              controller.showInfo.value ? 1 : 4,
                                          left: 10),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: blue_story),
                                        child: Text(
                                          widget.message.content,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              height: 1.2,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                  )
                : widget.message.type == 1
                    ? Flexible(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => FullImage(
                                    url: widget.message.content,
                                  ));
                            },
                            child: Hero(
                              tag: widget.message.content,
                              child: CachedNetworkImage(
                                imageUrl: "${widget.message.content}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  alignment: Alignment.centerLeft,
                                  height: UtilitiesSize.sizeHeight(200),
                                  width: UtilitiesSize.sizeWidth(250),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(15)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: UtilitiesSize.sizeHeight(200),
                                  width: UtilitiesSize.sizeWidth(250),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                        ),
                      )
                    // Sticker
                    : widget.message.type == 2
                        ? Flexible(child: Text('open video'))
                        : widget.message.type == 3
                            ? Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // open file
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text('thie is time'),
                                        widget.message.isShow
                                            ? Image.asset(
                                                'assets/icon/check_double.png',
                                                height: 15,
                                                width: 15,
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(
                                                CupertinoIcons.check_mark,
                                                size: 15,
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : widget.message.type == 6
                                ? Flexible(
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Image.asset(
                                          'assets/thumbs-up_1f44d.png',
                                          width: 60,
                                          fit: BoxFit.cover,
                                        )),
                                  )
                                : widget.message.type == 7
                                    ? Flexible(
                                        child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,

                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        child: voiceMessageWidge(
                                            widget.message.content),
                                      ))
                                    : Container()
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  widget.message.type == 0
                      ? Flexible(
                          child: Column(
                            children: [
                              Funct.buttonShowInfo(
                                  controller,
                                  Obx(
                                    () => Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        AnimatedOpacity(
                                          duration: Duration(
                                            milliseconds: 200,
                                          ),
                                          opacity:
                                              controller.showInfo.value ? 1 : 0,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 30),
                                            height: 20,
                                            width: 40,
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(Funct
                                                    .convertTimerToDataTime(
                                                        widget.message.time)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        AnimatedPadding(
                                          padding: EdgeInsets.only(
                                              bottom: controller.showInfo.value
                                                  ? 25
                                                  : 0),
                                          duration: Duration(milliseconds: 300),
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(
                                                left: 50, bottom: 4, right: 10),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.grey.shade100),
                                              child: Text(
                                                widget.message.content,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    height: 1.2,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : widget.message.type == 1
                          ? Flexible(
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(left: 10, top: 10),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => FullImage(
                                          url: widget.message.content,
                                        ));
                                  },
                                  child: Hero(
                                    tag: widget.message.content,
                                    child: CachedNetworkImage(
                                      imageUrl: "${widget.message.content}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        alignment: Alignment.centerLeft,
                                        height: UtilitiesSize.sizeHeight(200),
                                        width: UtilitiesSize.sizeWidth(250),
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(5)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        height: UtilitiesSize.sizeHeight(200),
                                        width: UtilitiesSize.sizeWidth(250),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                margin:
                                    EdgeInsets.only(bottom: 10.0, right: 10.0),
                              ),
                            )
                          : widget.message.type == 2
                              ? Flexible(child: Text("file"))
                              : widget.message.type == 3
                                  ? Flexible(child: Text('video'))
                                  : widget.message.type == 6
                                      ? Flexible(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Transform(
                                                alignment: Alignment.center,
                                                transform:
                                                    Matrix4.rotationY(math.pi),
                                                child: Image.asset(
                                                  'assets/thumbs-up_1f44d.png',
                                                  width: 60,
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        )
                                      : widget.message.type == 7
                                          ? Flexible(
                                              child: Container(
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1),
                                              child: voiceMessageWidge(
                                                  widget.message.content),
                                            ))
                                          : Container()
                ],
              ),
              // Time
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget voiceMessageWidge(message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: blue_story,
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () async {
                if (isPlay) {
                  await player.stop();
                } else if (clack) {
                  await player.stop();
                  await lodeFileVoic(message);
                  await player.resume();
                } else {
                  setState(() {
                    clack = true;
                  });

                  await lodeFileVoic(message);
                  await player.resume();
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  isPlay ? Icons.pause : Icons.play_arrow_sharp,
                  size: 30,
                ),
              ),
            ),
            Container(
              child: Slider(
                  inactiveColor: Colors.white,
                  activeColor: Colors.black,
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: pos.inSeconds.toDouble(),
                  onChanged: (v) async {
                    final poss = Duration(seconds: v.toInt());
                    await player.seek(poss);
                  }),
            ),
            Text(_printDuration(duration - pos))
          ],
        ),
      ),
    );
  }

  Future<void> lodeFileVoic(String url) async {
    player.setReleaseMode(ReleaseMode.RELEASE);
    await player.setUrl(url);
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
