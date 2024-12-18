import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/models/workout_model.dart';
import 'package:x_adaptor_gym/pages/homepage/workout_screen.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({super.key});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  ScrollController scrollController = ScrollController();

  List<WorkoutModel> beginner = [];
  List<WorkoutModel> intermediate = [];
  List<WorkoutModel> advance = [];
  List<WorkoutModel> likedPost = [];

  int selectedIndex = 0;
  String? userId;

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
        title: Text(
          AppStrings.workoutCategories,
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
            size: MediaQuery.of(context).size.height * 0.03,
          ),
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      ),
      body: beginner.isEmpty || intermediate.isEmpty || advance.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.02,
                right: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoSlidingSegmentedControl(
                    children: {
                      0: Text(
                        AppStrings.beginner,
                        style: TextStyle(
                          color: selectedIndex == 0
                              ? AppColors.blackColor
                              : AppColors.whiteColor,
                          fontFamily: AssetsFont.montserratBold,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize0018,
                        ),
                      ),
                      1: Text(
                        AppStrings.intermediate,
                        style: TextStyle(
                          color: selectedIndex == 1
                              ? AppColors.blackColor
                              : AppColors.whiteColor,
                          fontFamily: AssetsFont.montserratBold,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize0018,
                        ),
                      ),
                      2: Text(
                        AppStrings.advance,
                        style: TextStyle(
                          color: selectedIndex == 2
                              ? AppColors.blackColor
                              : AppColors.whiteColor,
                          fontFamily: AssetsFont.montserratBold,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize0018,
                        ),
                      ),
                    },
                    groupValue: selectedIndex,
                    backgroundColor: AppColors.lightBlackColor,
                    thumbColor: AppColors.neonYellowColor,
                    onValueChanged: (value) {
                      setState(() {
                        selectedIndex = value!;
                      });
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * double.infinity,
                    child: selectedIndex == 0
                        ? forBeginner(context)
                        : selectedIndex == 1
                            ? forIntermediate(context)
                            : forAdvance(context),
                  ),
                ],
              ),
            ),
    );
  }

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    debugPrint('User Id is:-$userId');
    getLikedData();
  }

  getBeginnerData() async {
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('workout_categories')
        .doc('beginner')
        .collection('beginner_posts')
        .get();
    if (snapShotData.toString().isNotEmpty) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          beginner.add(WorkoutModel(
              queryDocumentSnapshot: snapShotData.docs[i], isSelected: false));
        });
        if (likedPost.isNotEmpty) {
          for (int l = 0; l < likedPost.length; l++) {
            if (likedPost[l].queryDocumentSnapshot.id ==
                snapShotData.docs[i].id) {
              setState(() {
                beginner[i].isSelected = true;
              });
            }
          }
        }
      }
      debugPrint("Beginner Length${beginner.length}");
    }
  }

  getIntermediateData() async {
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('workout_categories')
        .doc('intermediate')
        .collection('intermediate_posts')
        .get();
    if (snapShotData.toString().isNotEmpty) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          intermediate.add(WorkoutModel(
              queryDocumentSnapshot: snapShotData.docs[i], isSelected: false));
        });
        if (likedPost.isNotEmpty) {
          for (int l = 0; l < likedPost.length; l++) {
            if (likedPost[l].queryDocumentSnapshot.id ==
                snapShotData.docs[i].id) {
              setState(() {
                intermediate[i].isSelected = true;
              });
            }
          }
        }
      }
      debugPrint("Intermediate Length${intermediate.length}");
    }
  }

  getAdvanceData() async {
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('workout_categories')
        .doc('advance')
        .collection('advance_posts')
        .get();
    if (snapShotData.toString().isNotEmpty) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          advance.add(WorkoutModel(
              queryDocumentSnapshot: snapShotData.docs[i], isSelected: false));
        });
        if (likedPost.isNotEmpty) {
          for (int l = 0; l < likedPost.length; l++) {
            if (likedPost[l].queryDocumentSnapshot.id ==
                snapShotData.docs[i].id) {
              setState(() {
                advance[i].isSelected = true;
              });
            }
          }
        }
      }
      debugPrint("Advance Length${advance.length}");
    }
  }

  getLikedData() async {
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('liked_workout')
        .doc(userId)
        .collection('workout_data')
        .get();
    if (snapShotData.toString().isNotEmpty) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          likedPost.add(WorkoutModel(
              queryDocumentSnapshot: snapShotData.docs[i], isSelected: true));
        });
      }
      debugPrint("Liked Length :- ${likedPost.length}");
    }
    getBeginnerData();
    getIntermediateData();
    getAdvanceData();
  }

  forBeginner(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: beginner.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutScreen(home: beginner[index]),
              ),
            );
            if (result == true || result == null) {
              setState(() {
                getId();
              });
            }
          },
          child: Card(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.02),
            elevation: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.01),
                  child: CachedNetworkImage(
                    imageUrl:
                        beginner[index].queryDocumentSnapshot.get('image'),
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * double.infinity,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0,
                  right: MediaQuery.of(context).size.height * 0,
                  child: IconButton(
                    onPressed: () {
                      if (beginner[index].isSelected == true) {
                        setState(() {
                          beginner[index].isSelected = false;
                          FirebaseFirestore.instance
                              .collection('liked_workout')
                              .doc(userId)
                              .collection('workout_data')
                              .doc(beginner[index].queryDocumentSnapshot.id)
                              .delete();
                        });
                      } else {
                        setState(() {
                          beginner[index].isSelected = true;
                          FirebaseFirestore.instance
                              .collection('liked_workout')
                              .doc(userId)
                              .collection('workout_data')
                              .doc(beginner[index].queryDocumentSnapshot.id)
                              .set({
                            'title': beginner[index]
                                .queryDocumentSnapshot
                                .get('title'),
                            'subtitle': beginner[index]
                                .queryDocumentSnapshot
                                .get('subtitle'),
                            'image': beginner[index]
                                .queryDocumentSnapshot
                                .get('image'),
                            'exercises': beginner[index]
                                .queryDocumentSnapshot
                                .get('exercises'),
                          });
                        });
                      }
                    },
                    icon: Icon(
                      beginner[index].isSelected == false
                          ? Icons.bookmark_border_rounded
                          : Icons.bookmark_rounded,
                      color: beginner[index].isSelected == false
                          ? AppColors.whiteColor
                          : Colors.redAccent,
                      size: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.025,
                  left: MediaQuery.of(context).size.height * 0.015,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: beginner[index]
                              .queryDocumentSnapshot
                              .get('title'),
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0014,
                          ),
                        ),
                        TextSpan(
                          text: '\n| ',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: AssetsFont.montserratBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0014,
                          ),
                        ),
                        TextSpan(
                          text: beginner[index]
                              .queryDocumentSnapshot
                              .get('subtitle'),
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratRegular,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0014,
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
      },
    );
  }

  forIntermediate(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: intermediate.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutScreen(home: intermediate[index]),
              ),
            );
            if (result == true || result == null) {
              setState(() {
                getId();
              });
            }
          },
          child: Card(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.02),
            elevation: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.01),
                  child: CachedNetworkImage(
                    imageUrl:
                        intermediate[index].queryDocumentSnapshot.get('image'),
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * double.infinity,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0,
                  right: MediaQuery.of(context).size.height * 0,
                  child: IconButton(
                    onPressed: () {
                      if (intermediate[index].isSelected == true) {
                        setState(() {
                          intermediate[index].isSelected = false;
                          FirebaseFirestore.instance
                              .collection('liked_workout')
                              .doc(userId)
                              .collection('workout_data')
                              .doc(intermediate[index].queryDocumentSnapshot.id)
                              .delete();
                        });
                      } else {
                        setState(() {
                          intermediate[index].isSelected = true;
                          FirebaseFirestore.instance
                              .collection('liked_workout')
                              .doc(userId)
                              .collection('workout_data')
                              .doc(intermediate[index].queryDocumentSnapshot.id)
                              .set({
                            'title': intermediate[index]
                                .queryDocumentSnapshot
                                .get('title'),
                            'subtitle': intermediate[index]
                                .queryDocumentSnapshot
                                .get('subtitle'),
                            'image': intermediate[index]
                                .queryDocumentSnapshot
                                .get('image'),
                            'exercises': intermediate[index]
                                .queryDocumentSnapshot
                                .get('exercises'),
                          });
                        });
                      }
                    },
                    icon: Icon(
                      intermediate[index].isSelected == false
                          ? Icons.bookmark_border_rounded
                          : Icons.bookmark_rounded,
                      color: intermediate[index].isSelected == false
                          ? AppColors.whiteColor
                          : Colors.redAccent,
                      size: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.025,
                  left: MediaQuery.of(context).size.height * 0.015,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: intermediate[index]
                              .queryDocumentSnapshot
                              .get('title'),
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0014,
                          ),
                        ),
                        TextSpan(
                          text: '\n| ',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: AssetsFont.montserratBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0014,
                          ),
                        ),
                        TextSpan(
                          text: intermediate[index]
                              .queryDocumentSnapshot
                              .get('subtitle'),
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratRegular,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0014,
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
      },
    );
  }

  forAdvance(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: advance.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutScreen(home: advance[index]),
              ),
            );
            if (result == true || result == null) {
              setState(() {
                getId();
              });
            }
          },
          child: Card(
            elevation: 5,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.02),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.01),
                  child: CachedNetworkImage(
                    imageUrl: advance[index].queryDocumentSnapshot.get('image'),
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * double.infinity,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0,
                  right: MediaQuery.of(context).size.height * 0,
                  child: IconButton(
                    onPressed: () {
                      if (advance[index].isSelected == true) {
                        setState(() {
                          advance[index].isSelected = false;
                          FirebaseFirestore.instance
                              .collection('liked_workout')
                              .doc(userId)
                              .collection('workout_data')
                              .doc(advance[index].queryDocumentSnapshot.id)
                              .delete();
                        });
                      } else {
                        setState(() {
                          advance[index].isSelected = true;
                          FirebaseFirestore.instance
                              .collection('liked_workout')
                              .doc(userId)
                              .collection('workout_data')
                              .doc(advance[index].queryDocumentSnapshot.id)
                              .set({
                            'title': advance[index]
                                .queryDocumentSnapshot
                                .get('title'),
                            'subtitle': advance[index]
                                .queryDocumentSnapshot
                                .get('subtitle'),
                            'image': advance[index]
                                .queryDocumentSnapshot
                                .get('image'),
                            'exercises': advance[index]
                                .queryDocumentSnapshot
                                .get('exercises'),
                          });
                        });
                      }
                    },
                    icon: Icon(
                      advance[index].isSelected == false
                          ? Icons.bookmark_border_rounded
                          : Icons.bookmark_rounded,
                      color: advance[index].isSelected == false
                          ? AppColors.whiteColor
                          : Colors.redAccent,
                      size: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.025,
                  left: MediaQuery.of(context).size.height * 0.015,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              advance[index].queryDocumentSnapshot.get('title'),
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0014,
                          ),
                        ),
                        TextSpan(
                          text: '\n| ',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: AssetsFont.montserratBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0014,
                          ),
                        ),
                        TextSpan(
                          text: advance[index]
                              .queryDocumentSnapshot
                              .get('subtitle'),
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratRegular,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0014,
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
      },
    );
  }
}
