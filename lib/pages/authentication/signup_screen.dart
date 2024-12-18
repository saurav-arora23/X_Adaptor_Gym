import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/appStyle/assets_image.dart';
import 'package:x_adaptor_gym/pages/authentication/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool passwordVisible = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(account!.id)
          .set({
        'username': account.displayName,
        'email': account.email,
        'gender': '',
        'age': null,
        'height': null,
        'weight': null,
      });
      debugPrint(" Details === ${account.id}");
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
              AppStrings.signUpPageTitle,
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
                AppStrings.signUpPageDes,
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
              controller: usernameController,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.lexendDecaSemiBold,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize002,
              ),
              cursorColor: AppColors.whiteColor,
              keyboardType: TextInputType.name,
              textAlign: TextAlign.justify,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.verified,
                  color: AppColors.blueColor,
                  size: MediaQuery.of(context).size.height * 0.022,
                ),
                label: Text(
                  AppStrings.nameLabel,
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
            TextButton(
              onPressed: () async {
                try {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  User? user = credential.user;
                  debugPrint(user!.uid);
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .set({
                    'username': usernameController.text,
                    'email': emailController.text,
                    'password': passwordController.text,
                    'gender': '',
                    'age': null,
                    'height': null,
                    'weight': null,
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    debugPrint('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    debugPrint('The account already exists for that email.');
                  }
                } catch (e) {
                  debugPrint(e.toString());
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
                    AppStrings.createAccount,
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
              AppStrings.signUpOption,
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
                  _googleSignIn!.signIn();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already-in-use') {
                    debugPrint('The account already exists for that email.');
                  }
                } on Exception catch (e) {
                  // TODO
                  debugPrint('exception->$e');
                }
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
                      AppStrings.googleSignUp,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.accountOption2,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontFamily: AssetsFont.lexendDecaRegular,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize002,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.signIn,
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
