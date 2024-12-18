import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/appStyle/assets_image.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? userId;
  List<QueryDocumentSnapshot> notification = [];

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    debugPrint('User Id is:-$userId');
    getNotificationData();
  }

  getNotificationData() async {
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('notifications')
        .doc(userId)
        .collection('notification_data')
        .get();
    if (snapShotData.toString().isNotEmpty) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          notification.add(snapShotData.docs[i]);
        });
      }
    }
    debugPrint("Notification Data -- ${notification.length}");
  }

  @override
  void initState() {
    getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        surfaceTintColor: AppColors.backGroundColor,
        centerTitle: true,
        title: Text(
          AppStrings.notifications,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontFamily: AssetsFont.montserratBold,
            fontSize:
                MediaQuery.of(context).size.height * AppDimensions.fontSize0026,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.whiteColor,
            size: MediaQuery.of(context).size.height * 0.035,
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.15,
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      ),
      body: notification.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: notification.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * 0.025),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AssetsImage.notification2,
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.035,
                          ),
                        ),
                      ),
                      title: Text(
                        notification[index].get('notification_title'),
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize0014,
                          fontFamily: AssetsFont.montserratBold,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('MMM dd , hh:mm').format(DateTime.parse(
                            notification[index].get('sentTime'))),
                        style: TextStyle(
                          color: AppColors.littleBrownColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize0014,
                          fontFamily: AssetsFont.montserratRegular,
                        ),
                      ),
                      /*trailing: Text(
                  notification[index].get('notification_body'),
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize0014,
                    fontFamily: AssetsFont.montserratBold,
                  ),
                ),*/
                    ),
                    Divider(
                      indent: MediaQuery.of(context).size.height * 0.02,
                      endIndent: MediaQuery.of(context).size.height * 0.02,
                      color: AppColors.alternateLightWhiteColor,
                    ),
                  ],
                );
              },
            )
          : Center(
              child: Text(
                "You Don't Have any Notification Yet",
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: AssetsFont.montserratBold,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize002),
              ),
            ),
    );
  }
}
