import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/appStyle/assets_image.dart';
import 'package:x_adaptor_gym/pages/authentication/otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

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
              AppStrings.forgotPassPageTitle,
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
                AppStrings.forgotPassPageDes,
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
              controller: emailController,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.lexendDecaSemiBold,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize002,
              ),
              cursorColor: AppColors.whiteColor,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.justify,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.verified,
                  color: AppColors.blueColor,
                  size: MediaQuery.of(context).size.height * 0.022,
                ),
                label: Text(
                  AppStrings.emailLabel,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize0014,
                    fontFamily: AssetsFont.lexendDecaRegular,
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
                    builder: (context) =>
                        OtpVerificationScreen(email: emailController.text),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.068,
                width: MediaQuery.of(context).size.width * double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.neonYellowColor,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
                child: Center(
                  child: Text(
                    AppStrings.submit,
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
