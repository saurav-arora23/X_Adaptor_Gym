import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/appStyle/assets_image.dart';
import 'package:x_adaptor_gym/pages/authentication/reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  OtpVerificationScreen({super.key, required this.email});
  String email = '';

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late Timer _timer;

  int _start = 30;

  bool timeOut = false;

  sendAgain() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request Time Out'),
      ),
    );
  }

  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _timer.cancel();
            timeOut = true;
            sendAgain();
            _start = 30;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        surfaceTintColor: AppColors.backGroundColor,
      ),
      body: Padding(
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
              AppStrings.otpPageTitle,
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
                AppStrings.otpPageDes + widget.email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontFamily: AssetsFont.lexendDecaRegular,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize002,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            PinCodeTextField(
              appContext: context,
              length: 4,
              backgroundColor: AppColors.backGroundColor,
              enableActiveFill: true,
              onCompleted: (v) {
                _timer.cancel();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetPasswordScreen(),
                  ),
                );
              },
              onChanged: (value) {
                setState(() {});
              },
              beforeTextPaste: (text) {
                debugPrint("Allowing to paste $text");
                return true;
              },
              keyboardType: TextInputType.phone,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              cursorColor: AppColors.backGroundColor,
              obscureText: false,
              pinTheme: PinTheme(
                inactiveColor: AppColors.alternateBrownColor,
                inactiveFillColor: AppColors.backGroundColor,
                selectedFillColor: AppColors.neonYellowColor,
                activeColor: AppColors.neonYellowColor,
                selectedColor: AppColors.neonYellowColor,
                disabledColor: AppColors.backGroundColor,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height * 0.008,
                ),
                fieldHeight: MediaQuery.of(context).size.height * 0.05,
                fieldWidth: MediaQuery.of(context).size.width * 0.1,
                activeFillColor: AppColors.neonYellowColor,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            timeOut == false
                ? Text(
                    '$_start',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontFamily: AssetsFont.lexendDecaSemiBold,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize0018,
                    ),
                  )
                : const SizedBox(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetPasswordScreen(),
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
                    AppStrings.submit,
                    style: TextStyle(
                      color: AppColors.backGroundColor,
                      fontSize: MediaQuery.of(context).size.height * 0.024,
                      fontFamily: AssetsFont.lexendDecaSemiBold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.35),
            TextButton(
              onPressed: () {
                setState(() {
                  timeOut = false;
                });
                startTimer();
              },
              child: timeOut == true
                  ? Center(
                      child: Text(
                        AppStrings.sendAgain,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize002,
                          fontFamily: AssetsFont.lexendDecaSemiBold,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
