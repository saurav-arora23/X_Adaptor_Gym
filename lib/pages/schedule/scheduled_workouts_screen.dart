import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/models/workout_model.dart';
import 'package:x_adaptor_gym/pages/homepage/workout_screen.dart';

class ScheduledWorkoutsScreen extends StatefulWidget {
  const ScheduledWorkoutsScreen({super.key});

  @override
  State<ScheduledWorkoutsScreen> createState() =>
      _ScheduledWorkoutsScreenState();
}

class _ScheduledWorkoutsScreenState extends State<ScheduledWorkoutsScreen> {
  List<WorkoutModel> sched = [];
  List<WorkoutModel> likedPost = [];
  String? userId;

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
    }
    getScheduleData();
  }

  getScheduleData() async {
    sched.clear();
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('schedule_workout')
        .doc(userId)
        .collection('workout_data')
        .get();
    if (snapShotData != null) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        if (DateTime.parse(snapShotData.docs[i].get('schedule_DateTime'))
            .isAfter(DateTime.now())) {
          setState(() {
            sched.add(WorkoutModel(
                queryDocumentSnapshot: snapShotData.docs[i],
                isSelected: false));
          });
        }
        if (likedPost.isNotEmpty) {
          for (int l = 0; l < likedPost.length; l++) {
            if (likedPost[l].queryDocumentSnapshot.id ==
                snapShotData.docs[i].id) {
              setState(() {
                sched[i].isSelected = true;
              });
            }
          }
        }
      }
    }
    debugPrint("Scheduled Workouts --- ${sched.length}");
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
        leading: Container(),
        title: Text(
          AppStrings.workoutSchedulePageTitle,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontFamily: AssetsFont.montserratBold,
            fontSize:
                MediaQuery.of(context).size.height * AppDimensions.fontSize0024,
          ),
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.workoutSchedulePageDes,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AssetsFont.montserratRegular,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize0018,
              ),
            ),
            sched.isEmpty
                ? Text(
                    "You Don't Have any Scheduled WorkOut",
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontFamily: AssetsFont.montserratBold,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize002),
                  )
                : ListView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                    itemCount: sched.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutScreen(home: sched[index]),
                            ),
                          );
                        },
                        child: Card(
                          color: AppColors.backGroundColor,
                          surfaceTintColor: AppColors.backGroundColor,
                          elevation: 2,
                          margin: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.02),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: sched[index]
                                    .queryDocumentSnapshot
                                    .get('image'),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.01,
                                right:
                                    MediaQuery.of(context).size.height * 0.01,
                                child: IconButton(
                                  onPressed: () {
                                    if (sched[index].isSelected == true) {
                                      setState(() {
                                        sched[index].isSelected = false;
                                        FirebaseFirestore.instance
                                            .collection('liked_workout')
                                            .doc(userId)
                                            .collection('workout_data')
                                            .doc(sched[index]
                                                .queryDocumentSnapshot
                                                .id)
                                            .delete();
                                      });
                                    } else {
                                      setState(() {
                                        sched[index].isSelected = true;
                                        FirebaseFirestore.instance
                                            .collection('liked_workout')
                                            .doc(userId)
                                            .collection('workout_data')
                                            .doc(sched[index]
                                                .queryDocumentSnapshot
                                                .id)
                                            .set({
                                          'title': sched[index]
                                              .queryDocumentSnapshot
                                              .get('title'),
                                          'subtitle': sched[index]
                                              .queryDocumentSnapshot
                                              .get('subtitle'),
                                          'image': sched[index]
                                              .queryDocumentSnapshot
                                              .get('image'),
                                        });
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    sched[index].isSelected == false
                                        ? Icons.bookmark_border_outlined
                                        : Icons.bookmark_rounded,
                                    color: sched[index].isSelected == false
                                        ? AppColors.whiteColor
                                        : Colors.redAccent,
                                    size: MediaQuery.of(context).size.height *
                                        0.04,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                                left: MediaQuery.of(context).size.height * 0.01,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: sched[index]
                                            .queryDocumentSnapshot
                                            .get('title'),
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontFamily: AssetsFont.montserratBold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              AppDimensions.fontSize0014,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '\n${DateFormat(' MMMM dd hh:mm a').format(DateTime.parse(sched[index].queryDocumentSnapshot.get('schedule_DateTime').toString()))}',
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontFamily:
                                              AssetsFont.montserratRegular,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                  ),
          ],
        ),
      ),
    );
  }
}
