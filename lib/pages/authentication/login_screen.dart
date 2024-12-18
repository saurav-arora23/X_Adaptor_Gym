import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/appStyle/assets_image.dart';
import 'package:x_adaptor_gym/pages/authentication/forgot_password_screen.dart';
import 'package:x_adaptor_gym/pages/authentication/signup_screen.dart';
import 'package:x_adaptor_gym/pages/bottom_navigation_bar_screen.dart';
import 'package:x_adaptor_gym/pages/onBoarding/select_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  String? token;

  List<String> scopes = <String>[
    'email',
  ];

  GoogleSignIn? _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(scopes: scopes);
    _googleSignIn?.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('UserID', account!.id);
      setState(() {
        token = prefs.getString('UserID');
      });
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(token).get();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => snapshot.get('gender') == ''
              ? const SelectProfileScreen()
              : const BottomNavigationBarScreen(),
        ),
      );
    });
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
            SvgPicture.asset(AssetsImage.logo),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              AppStrings.loginPageTitle,
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
                right: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Text(
                AppStrings.loginPageDes,
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
            TextFormField(
              controller: passwordController,
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
                  AppStrings.passwordLabel,
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
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  AppStrings.forgotPassPageTitle,
                  style: TextStyle(
                    color: AppColors.neonYellowColor,
                    fontFamily: AssetsFont.lexendDecaRegular,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize0018,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            TextButton(
              onPressed: () async {
                try {
                  final credential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('UserID', credential.user!.uid);

                  DocumentSnapshot snapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(prefs.getString('UserID'))
                      .get();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => snapshot.get('gender') == ""
                          ? const SelectProfileScreen()
                          : const BottomNavigationBarScreen(),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    debugPrint('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    debugPrint('Wrong password provided for that user.');
                  }
                }
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
                    AppStrings.login,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              AppStrings.loginOption,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.lexendDecaRegular,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize0024,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            TextButton(
              onPressed: () async {
                try {
                  _googleSignIn?.signIn();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'wrong-password') {
                    debugPrint('Wrong password provided for that user.');
                  }
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.068,
                width: MediaQuery.of(context).size.width * double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height *
                          AppDimensions.fontSize002,
                    ),
                    border: Border.all(color: AppColors.whiteColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AssetsImage.googleIcon),
                    Text(
                      AppStrings.googleLogin,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize0024,
                        fontFamily: AssetsFont.lexendDecaSemiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.045),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.accountOption1,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontFamily: AssetsFont.lexendDecaRegular,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize002,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.signUp,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontFamily: AssetsFont.lexendDecaSemiBold,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize002,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
