import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';

class AppTextThemeStyle {
  //Light
  Widget commonBlackLightText(
      BuildContext context, String title, double fontSize) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.blackColor,
        fontFamily: AssetsFont.lexendDecaLight,
        fontSize: MediaQuery.of(context).size.height * fontSize,
      ),
    );
  }
}
