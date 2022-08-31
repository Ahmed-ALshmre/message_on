import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class FullImage extends StatelessWidget {
  final String url;
  const FullImage({Key? key,required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(onPressed: (){
              Get.back();
            },
                icon: Icon(Icons.clear,color: Colors.black,size: 35,)),
          ),
          body: Center(
            child:Hero(
              tag: url,
              child: CachedNetworkImage(
                imageUrl: "$url",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
        ));
  }
}
