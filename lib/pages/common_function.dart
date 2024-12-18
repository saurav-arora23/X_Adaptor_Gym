import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/models/workout_model.dart';
import 'package:x_adaptor_gym/pages/bottom_navigation_bar_screen.dart';

class CommonFunction {
  static dialogBox(BuildContext context, String userId, WorkoutModel home) {
    return Dialog(
      surfaceTintColor: AppColors.whiteColor,
      elevation: 5,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
          color: AppColors.backGroundColor,
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
        ),
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.neonYellowColor,
              size: MediaQuery.of(context).size.height * 0.12,
            ),
            Text(
              AppStrings.popUpTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.montserratRegular,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('workout_progress')
                    .doc(userId)
                    .collection('progress_data')
                    .doc(home.queryDocumentSnapshot.id)
                    .update({
                  'completed_time': DateTime.now().toString(),
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigationBarScreen(),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.neonYellowColor,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
                child: Center(
                  child: Text(
                    AppStrings.nextSteps,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize0025,
                      fontFamily: AssetsFont.montserratBold,
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
