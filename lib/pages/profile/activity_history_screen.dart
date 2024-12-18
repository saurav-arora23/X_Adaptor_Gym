import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/models/workout_model.dart';
import 'package:x_adaptor_gym/pages/homepage/workout_screen.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  ScrollController scrollController = ScrollController();

  List<WorkoutModel> allWorkout = [];
  List<WorkoutModel> likedPost = [];
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
          AppStrings.activityHistory,
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
      body: allWorkout.isEmpty
          ? Center(
              child: Text(
                "You don't have any Activity History Available",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontFamily: AssetsFont.montserratBold,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize002,
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.02,
                right: MediaQuery.of(context).size.height * 0.01,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * double.infinity,
                child: forCompletedWorkout(context),
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

  getLikedData() async {
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('liked_workout')
        .doc(userId)
        .collection('workout_data')
        .get();
    if (snapShotData != null) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          likedPost.add(WorkoutModel(
              queryDocumentSnapshot: snapShotData.docs[i], isSelected: true));
        });
      }
      debugPrint("Liked Length :- ${likedPost.length}");
    }
    getTodayWorkoutData();
  }

  getTodayWorkoutData() async {
    allWorkout.clear();
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('workout_progress')
        .doc(userId)
        .collection('progress_data')
        .get();
    if (snapShotData != null) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          allWorkout.add(WorkoutModel(
              queryDocumentSnapshot: snapShotData.docs[i], isSelected: false));
        });
        if (likedPost.isNotEmpty) {
          for (int l = 0; l < likedPost.length; l++) {
            if (likedPost[l].queryDocumentSnapshot.id ==
                snapShotData.docs[i].id) {
              setState(() {
                allWorkout[i].isSelected = true;
              });
            }
          }
        }
      }
    }
    debugPrint("Today Workout Data ${allWorkout.length}");
  }

  forCompletedWorkout(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: allWorkout.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutScreen(home: allWorkout[index]),
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
                        allWorkout[index].queryDocumentSnapshot.get('image'),
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
                      if (allWorkout[index].isSelected == true) {
                        setState(() {
                          allWorkout[index].isSelected = false;
                          FirebaseFirestore.instance
                              .collection('liked_workout')
                              .doc(userId)
                              .collection('workout_data')
                              .doc(allWorkout[index].queryDocumentSnapshot.id)
                              .delete();
                        });
                      } else {
                        setState(() {
                          allWorkout[index].isSelected = true;
                          FirebaseFirestore.instance
                              .collection('liked_workout')
                              .doc(userId)
                              .collection('workout_data')
                              .doc(allWorkout[index].queryDocumentSnapshot.id)
                              .set({
                            'title': allWorkout[index]
                                .queryDocumentSnapshot
                                .get('title'),
                            'subtitle': allWorkout[index]
                                .queryDocumentSnapshot
                                .get('subtitle'),
                            'image': allWorkout[index]
                                .queryDocumentSnapshot
                                .get('image'),
                            'exercises': allWorkout[index]
                                .queryDocumentSnapshot
                                .get('exercises'),
                          });
                        });
                      }
                    },
                    icon: Icon(
                      allWorkout[index].isSelected == false
                          ? Icons.bookmark_border_rounded
                          : Icons.bookmark_rounded,
                      color: allWorkout[index].isSelected == false
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
                          text: allWorkout[index]
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
                          text: allWorkout[index]
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
