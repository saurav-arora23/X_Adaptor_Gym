import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/appStyle/assets_image.dart';
import 'package:x_adaptor_gym/pages/onBoarding/select_age_screen.dart';

class SelectGenderScreen extends StatefulWidget {
  const SelectGenderScreen({super.key});

  @override
  State<SelectGenderScreen> createState() => _SelectGenderScreenState();
}

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  bool man = false;
  bool woman = false;

  String? userId;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    debugPrint('User Id is:-$userId');
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.genderPageTitle,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.lexendDecaRegular,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize0032,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              AppStrings.genderPageDes,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.lexendDecaRegular,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize0018,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            GestureDetector(
              onTap: () {
                setState(() {
                  man = true;
                  woman = false;
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                  color: AppColors.backGroundColor,
                  border: Border.all(color: AppColors.whiteColor),
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.01,
                  ),
                ),
                child: Stack(
                  children: [
                    man == true
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.blueColor,
                              size: MediaQuery.of(context).size.height * 0.03,
                            ),
                          )
                        : const SizedBox(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetsImage.male,
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.35,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          AppStrings.man,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.lexendDecaRegular,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0018,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            GestureDetector(
              onTap: () {
                setState(() {
                  man = false;
                  woman = true;
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                  color: AppColors.backGroundColor,
                  border: Border.all(color: AppColors.whiteColor),
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.01,
                  ),
                ),
                child: Stack(
                  children: [
                    woman == true
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.blueColor,
                              size: MediaQuery.of(context).size.height * 0.03,
                            ),
                          )
                        : const SizedBox(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetsImage.female,
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.35,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          AppStrings.woman,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.lexendDecaRegular,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0018,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({
                  'gender': man == true ? 'Man' : 'Woman',
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectAgeScreen(),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.068,
                width: MediaQuery.of(context).size.width * double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.neonYellowColor,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height *
                        AppDimensions.fontSize002,
                  ),
                ),
                child: Center(
                  child: Text(
                    AppStrings.continues,
                    style: TextStyle(
                      color: AppColors.backGroundColor,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize0024,
                      fontFamily: AssetsFont.lexendDecaSemiBold,
                    ),
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
