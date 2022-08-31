import 'dart:io';

import 'package:dio/dio.dart';
import 'package:messages/model/notification.dart';
class UploadFile{
  static String url = "";
  static String imageRoute = "";
  static String voiceRoute = "";
  static Future<String> serverFile(File file,String urlRoute) async {
    try {
      String url = urlRoute;
      String fileName = file.path.split('/').last;
      FormData data = await FormData.fromMap({
        "mFile": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      Dio dio = new Dio();
      final res = await dio
          .post(url, data: data)
          .timeout(Duration(seconds: 60));

      if (res.statusCode == 200) {
        print(res.data['data']);
        return res.data['data'];
      } else {
        return '';
      }
    } on DioError catch (e) {
      print(e);

      return "";
    }
  }
  static sendNotification(Notification notification){
    /// coll with api firebase
  }
}