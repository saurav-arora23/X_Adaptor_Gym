import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/appStyle/assets_image.dart';
import 'package:x_adaptor_gym/pages/authentication/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

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
            SvgPicture.asset(AssetsImage.logo),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              AppStrings.resetPassPageTitle,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.lexendDecaRegular,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize0032,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Text(
                AppStrings.resetPassPageDes,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontFamily: AssetsFont.lexendDecaRegular,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize002,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            TextFormField(
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.lexendDecaSemiBold,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize002,
              ),
              cursorColor: AppColors.whiteColor,
              textAlign: TextAlign.justify,
              obscureText: passwordVisible == false ? true : false,
              decoration: InputDecoration(
                label: Text(
                  AppStrings.newPassword,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize0014,
                    fontFamily: AssetsFont.lexendDecaRegular,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    if (passwordVisible == false) {
                      setState(() {
                        passwordVisible = true;
                      });
                    } else {
                      setState(() {
                        passwordVisible = false;
                      });
                    }
                  },
                  icon: passwordVisible == false
                      ? Icon(
                          Icons.visibility_off_outlined,
                          color: AppColors.whiteColor,
                          size: MediaQuery.of(context).size.height * 0.022,
                        )
                      : Icon(
                          Icons.visibility_outlined,
                          color: AppColors.whiteColor,
                          size: MediaQuery.of(context).size.height * 0.022,
                        ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                  borderSide: const BorderSide(color: AppColors.whiteColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                  borderSide: const BorderSide(color: AppColors.whiteColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                  borderSide: const BorderSide(color: AppColors.whiteColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                  borderSide: const BorderSide(color: AppColors.whiteColor),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            TextFormField(
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.lexendDecaSemiBold,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize002,
              ),
              cursorColor: AppColors.whiteColor,
              textAlign: TextAlign.justify,
              obscureText: confirmPasswordVisible == false ? true : false,
              decoration: InputDecoration(
                label: Text(
                  AppStrings.confirmPassword,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize0014,
                    fontFamily: AssetsFont.lexendDecaRegular,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    if (confirmPasswordVisible == false) {
                      setState(() {
                        confirmPasswordVisible = true;
                      });
                    } else {
                      setState(() {
                        confirmPasswordVisible = false;
                      });
                    }
                  },
                  icon: confirmPasswordVisible == false
                      ? Icon(
                          Icons.visibility_off_outlined,
                          color: AppColors.whiteColor,
                          size: MediaQuery.of(context).size.height * 0.022,
                        )
                      : Icon(
                          Icons.visibility_outlined,
                          color: AppColors.whiteColor,
                          size: MediaQuery.of(context).size.height * 0.022,
                        ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                  borderSide: const BorderSide(color: AppColors.whiteColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                  borderSide: const BorderSide(color: AppColors.whiteColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                  borderSide: const BorderSide(color: AppColors.whiteColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                  borderSide: const BorderSide(color: AppColors.whiteColor),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
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
                    AppStrings.saveChanges,
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
