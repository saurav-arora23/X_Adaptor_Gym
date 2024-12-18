import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/appStyle/assets_image.dart';
import 'package:x_adaptor_gym/pages/onBoarding/select_height_screen.dart';
import 'package:x_adaptor_gym/pages/onBoarding/select_weight_screen.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? userId;
  String? name;
  String? email;
  int? height;
  int? weight;
  int? age;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID')!;
    debugPrint('User Id is:-$userId');
    getData();
  }

  getData() async {
    DocumentSnapshot<Map<String, dynamic>> snapShotData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapShotData != null) {
      setState(() {
        name = snapShotData.get("username");
        email = snapShotData.get("email");
        height = snapShotData.get("height");
        weight = snapShotData.get("weight");
        age = snapShotData.get("age");
        nameController.text = name!;
        emailController.text = email!;
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
        centerTitle: true,
        title: Text(
          AppStrings.personalDataTitle,
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
      body: name == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.38,
                      decoration: BoxDecoration(
                        color: AppColors.backGroundColor,
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.2),
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
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    'UserName',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontFamily: AssetsFont.montserratBold,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize0022,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightBlackColor,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.015),
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontFamily: AssetsFont.montserratBold,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize002,
                      ),
                      controller: nameController,
                      cursorColor: AppColors.whiteColor,
                      onChanged: (v) async {
                        setState(() {
                          nameController.text = v;
                        });
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .update({'username': nameController.text});
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    'Email',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontFamily: AssetsFont.montserratBold,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize0022,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightBlackColor,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.015),
                    ),
                    child: TextFormField(
                      cursorColor: AppColors.whiteColor,
                      readOnly: true,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontFamily: AssetsFont.montserratBold,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize002,
                      ),
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    'Personal Data',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontFamily: AssetsFont.montserratBold,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize0022,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SelectHeightScreen(),
                            ),
                          );
                        },
                        child: Container(
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
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SelectWeightScreen(),
                            ),
                          );
                        },
                        child: Container(
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
                ],
              ),
            ),
    );
  }
}
