import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/pages/bottom_navigation_bar_screen.dart';

class SelectWeightScreen extends StatefulWidget {
  const SelectWeightScreen({super.key});

  @override
  State<SelectWeightScreen> createState() => _SelectWeightScreenState();
}

class _SelectWeightScreenState extends State<SelectWeightScreen> {
  List<String> weights = [
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100'
  ];

  int selectedItemIndex = 0;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.weightPageTitle,
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
              left: MediaQuery.of(context).size.height * 0.04,
              right: MediaQuery.of(context).size.height * 0.04,
            ),
            child: Text(
              AppStrings.weightPageDes,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.lexendDecaRegular,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize0018,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * double.infinity,
            child: RotatedBox(
              quarterTurns: 3,
              child: CupertinoPicker(
                selectionOverlay: Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
                itemExtent: MediaQuery.of(context).size.height * 0.07,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedItemIndex = int.parse(weights[index]);
                  });
                },
                children: List.generate(
                  weights.length,
                  (int index) {
                    return RotatedBox(
                      quarterTurns: 1,
                      child: Center(
                        child: selectedItemIndex == int.parse(weights[index])
                            ? Text(
                                weights[index].toString(),
                                style: TextStyle(
                                  color: AppColors.neonYellowColor,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize0035,
                                  fontFamily: AssetsFont.montserratRegular,
                                ),
                              )
                            : Text(
                                weights[index].toString(),
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize0030,
                                  fontFamily: AssetsFont.montserratRegular,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .update({
                'weight': selectedItemIndex,
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavigationBarScreen(),
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
    );
  }
}
