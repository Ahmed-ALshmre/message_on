import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messages/model/addNewUser.dart';
import '../../shop/product.dart';
import '../../utility/theme.dart';
import '../../utility/utilitiesSize.dart';


class ProductChatScreen extends StatelessWidget {
  final NewUserAddToChatModel newUserAddToChatModel;
   ProductChatScreen({Key? key,required this.newUserAddToChatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  newUserAddToChatModel.idProduct!.isNotEmpty ?  Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: ColorTheme.secondaryColor,
        alignment: Alignment.center,
        height: 40,
        width: UtilitiesSize.fullScreenWidth(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {},
              child: InkWell(
                onTap: () {
                  Get.to(() => Product());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    newUserAddToChatModel.imageProduct!.isNotEmpty ? CachedNetworkImage(
                      imageUrl:
                      newUserAddToChatModel.imageProduct.toString(),
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            height: UtilitiesSize.sizeHeight(50),
                            width: UtilitiesSize.sizeWidth(50),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    ):SizedBox.shrink(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: UtilitiesSize.fullScreenWidth(
                                context) *
                                0.4,
                            height: UtilitiesSize.fullScreenWidth(
                                context) *
                                0.05,
                            child: Text(
                              newUserAddToChatModel.titleProduct.toString(),
                              style: TextStyle(
                                height: 1,
                                fontSize: UtilitiesSize.fontSize10(12),
                                color: ColorTheme.fontColor,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    ):Container();
  }
}
