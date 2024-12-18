import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/appStyle/assets_image.dart';
import 'package:x_adaptor_gym/pages/authentication/login_screen.dart';
import 'package:x_adaptor_gym/pages/profile/achievement_screen.dart';
import 'package:x_adaptor_gym/pages/profile/activity_history_screen.dart';
import 'package:x_adaptor_gym/pages/profile/like_post_screen.dart';
import 'package:x_adaptor_gym/pages/profile/personal_data_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool? not;
  String? userId;
  String? name;
  String? email;
  int? height;
  int? weight;
  int? age;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    debugPrint('User Id is:-$userId');
    getData();
  }

  removeId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('UserID');
  }

  getData() async {
    DocumentSnapshot<Map<String, dynamic>> snapShotData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapShotData.toString().isNotEmpty) {
      setState(() {
        name = snapShotData.get("username");
        email = snapShotData.get("email");
        height = snapShotData.get("height");
        weight = snapShotData.get("weight");
        age = snapShotData.get("age");
        not = snapShotData.get("notification");
      });
    }
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
        toolbarHeight: MediaQuery.of(context).size.height * 0.02,
      ),
      body: name == null
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.whiteColor,
              ),
            )
          : Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.21,
                        decoration: BoxDecoration(
                          color: AppColors.backGroundColor,
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * 0.05),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * 0.05),
                          child: Image.asset(
                            AssetsImage.profile,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name.toString(),
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontFamily: AssetsFont.montserratBold,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize0022,
                            ),
                          ),
                          Text(
                            email.toString(),
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontFamily: AssetsFont.montserratRegular,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize0016,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlackColor,
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.015,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$height cm',
                              style: TextStyle(
                                color: AppColors.neonYellowColor,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize0022,
                                fontFamily: AssetsFont.montserratBold,
                              ),
                            ),
                            Text(
                              'Height',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize0022,
                                fontFamily: AssetsFont.montserratRegular,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlackColor,
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.015,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$weight kg',
                              style: TextStyle(
                                color: AppColors.neonYellowColor,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize0022,
                                fontFamily: AssetsFont.montserratBold,
                              ),
                            ),
                            Text(
                              'Weight',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize0022,
                                fontFamily: AssetsFont.montserratRegular,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlackColor,
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.015,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$age yo',
                              style: TextStyle(
                                color: AppColors.neonYellowColor,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize0022,
                                fontFamily: AssetsFont.montserratBold,
                              ),
                            ),
                            Text(
                              'Age',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize0022,
                                fontFamily: AssetsFont.montserratRegular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Text(
                    'Account',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize0022,
                      fontFamily: AssetsFont.montserratBold,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalDataScreen(),
                        ),
                      );
                      if (result == true || result == null) {
                        setState(() {
                          getId();
                        });
                      }
                    },
                    leading: Icon(
                      Icons.person_outline_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                    title: Text(
                      'Personal Data',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize0022,
                        fontFamily: AssetsFont.montserratRegular,
                      ),
                    ),
                    trailing: Icon(
                      Icons.navigate_next_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AchievementScreen(),
                        ),
                      );
                      if (result == true || result == null) {
                        setState(() {
                          getId();
                        });
                      }
                    },
                    leading: Icon(
                      Icons.sticky_note_2_outlined,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                    title: Text(
                      'Achievement',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize0022,
                        fontFamily: AssetsFont.montserratRegular,
                      ),
                    ),
                    trailing: Icon(
                      Icons.navigate_next_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ActivityHistoryScreen(),
                        ),
                      );
                      if (result == true || result == null) {
                        setState(() {
                          getId();
                        });
                      }
                    },
                    leading: Icon(
                      Icons.history_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                    title: Text(
                      'Activity History',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize0022,
                        fontFamily: AssetsFont.montserratRegular,
                      ),
                    ),
                    trailing: Icon(
                      Icons.navigate_next_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LikePostScreen(),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.bookmark_outline_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                    title: Text(
                      'Like',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize0022,
                        fontFamily: AssetsFont.montserratRegular,
                      ),
                    ),
                    trailing: Icon(
                      Icons.navigate_next_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      removeId();
                      FirebaseAuth.instance.signOut();
                      await GoogleSignIn().signOut();
                    },
                    leading: Icon(
                      Icons.logout_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                    title: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize0022,
                        fontFamily: AssetsFont.montserratRegular,
                      ),
                    ),
                    trailing: Icon(
                      Icons.navigate_next_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    'Notification',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize0022,
                      fontFamily: AssetsFont.montserratBold,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      if (not == false) {
                        setState(() {
                          not = true;
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .update({
                            'notification': not,
                          });
                          FirebaseMessaging.instance.setAutoInitEnabled(true);
                          FirebaseMessaging.instance.requestPermission(
                            alert: true,
                            sound: true,
                            badge: true,
                          );
                        });
                      } else {
                        setState(() {
                          not = false;
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .update({
                            'notification': not,
                          });
                          FirebaseMessaging.instance.setAutoInitEnabled(false);
                          FirebaseMessaging.instance.requestPermission(
                            alert: false,
                            sound: false,
                            badge: false,
                          );
                        });
                      }
                    },
                    leading: Icon(
                      Icons.notifications_none_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: AppColors.lightWhiteColor,
                    ),
                    title: Text(
                      'Pop-Up notification',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize0022,
                        fontFamily: AssetsFont.montserratRegular,
                      ),
                    ),
                    trailing: Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        color: not == true
                            ? AppColors.lightBlueColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.02,
                        ),
                      ),
                      child: not == false
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.circle,
                                size: MediaQuery.of(context).size.height * 0.03,
                                color: AppColors.lightBlueColor,
                              ),
                            )
                          : Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.circle,
                                size: MediaQuery.of(context).size.height * 0.03,
                                color: AppColors.whiteColor,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
