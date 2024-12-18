import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/pages/onBoarding/select_gender_screen.dart';

class SelectProfileScreen extends StatefulWidget {
  const SelectProfileScreen({super.key});

  @override
  State<SelectProfileScreen> createState() => _SelectProfileScreenState();
}

class _SelectProfileScreenState extends State<SelectProfileScreen> {
  File? imageController;
/*  String? imageUrl;
  String? image;*/

  final _picker = ImagePicker();

/*  uploadImage() async {
    //FireBase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref(userId).child("$userId/$imageController");
    //Upload Image Url
    UploadTask uploadTask = ref.putFile(imageController!);
    await uploadTask.whenComplete(() async {
      var url = await ref.getDownloadURL();
      imageUrl = url.toString();
    });
    //FireBase DataBase
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'image': imageUrl});
    DocumentSnapshot<Map<String, dynamic>> snapShotData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapShotData != null) {
      setState(() {
        image = snapShotData.get("image");
      });
    }
  }*/

  void _openImagePicker(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        imageController = File(pickedImage.path);
        /*uploadImage();*/
      });
    }
  }

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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.photoPageTitle,
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
              AppStrings.photoPageDes,
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
          CircleAvatar(
            radius: MediaQuery.of(context).size.height * 0.065,
            backgroundColor: AppColors.alternateLightWhiteColor,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.065,
                  backgroundColor: AppColors.alternateLightWhiteColor,
                  child: Align(
                    alignment: Alignment.center,
                    child: imageController != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * 0.22),
                            child: Image.file(
                              imageController!,
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.28,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.018,
                    backgroundColor: AppColors.backGroundColor,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.height * 0.015,
                      backgroundColor: AppColors.neonYellowColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          size: MediaQuery.of(context).size.height * 0.014,
                          color: AppColors.backGroundColor,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                backgroundColor: AppColors.backGroundColor,
                                title: Text(
                                  AppStrings.profilePicturesDialogTitle,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontFamily: AssetsFont.lexendDecaRegular,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            AppDimensions.fontSize0025,
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.start,
                                actions: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                      border: Border.all(
                                          color: AppColors.neonYellowColor),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.photo_camera_back_sharp,
                                        color: AppColors.neonYellowColor,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.023,
                                      ),
                                      onPressed: () {
                                        _openImagePicker(ImageSource.gallery);
                                        Navigator.of(context)
                                            .pop(); // Dismiss alert dialog
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                      border: Border.all(
                                          color: AppColors.neonYellowColor),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt_rounded,
                                        color: AppColors.neonYellowColor,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.023,
                                      ),
                                      onPressed: () {
                                        _openImagePicker(ImageSource.camera);
                                        Navigator.of(context)
                                            .pop(); // Dismiss alert dialog
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          TextButton(
            onPressed: () async {
              if (imageController == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image is Required'),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectGenderScreen(),
                  ),
                );
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
                  imageController == null
                      ? AppStrings.saveChanges
                      : AppStrings.continues,
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
