import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:intl/intl.dart';
import 'package:x_adaptor_gym/models/workout_model.dart';
import 'package:x_adaptor_gym/pages/homepage/workout_preview_screen.dart';

class WorkoutScreen extends StatefulWidget {
  WorkoutScreen({super.key, required this.home});
  WorkoutModel home;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  ScrollController scrollController = ScrollController();

  bool exerciseSelected = false;
  DateTime sDT = DateTime.now();
  String? title;
  String? video;
  String? time;
  String? userId;

  List<Map<String, dynamic>> exercise = [];
  List<WorkoutModel> sched = [];
  List<bool> selectedExercises = [];

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    debugPrint('User Id is:-$userId');
  }

  getExerciseData() {
    setState(() {
      exercise = List.from(widget.home.queryDocumentSnapshot.get("exercises"));
    });
  }

  showDateTime() async {
    return showDatePicker(
      barrierDismissible: true,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((selectedDate) {
      if (selectedDate != null && selectedDate.isAfter(DateTime.now())) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((selectedTime) {
          if (selectedTime != null) {
            DateTime selectedDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            setState(() {
              sDT = selectedDateTime;
              FirebaseFirestore.instance
                  .collection('schedule_workout')
                  .doc(userId)
                  .collection('workout_data')
                  .doc(widget.home.queryDocumentSnapshot.id)
                  .set({
                'title': widget.home.queryDocumentSnapshot.get('title'),
                'subtitle': widget.home.queryDocumentSnapshot.get('subtitle'),
                'image': widget.home.queryDocumentSnapshot.get('image'),
                'exercises': widget.home.queryDocumentSnapshot.get('exercises'),
                'schedule_DateTime': sDT.toString(),
              });
            });
          }
        });
      } else {
        showDateTime();
      }
    });
  }

  getScheduleData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('schedule_workout')
        .doc(userId)
        .collection('workout_data')
        .get();
    if (snapShotData.toString().isNotEmpty) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          sched.add(WorkoutModel(
              queryDocumentSnapshot: snapShotData.docs[i], isSelected: false));
        });
        if (sched.isNotEmpty) {
          for (int s = 0; s < sched.length; s++) {
            if (sched[s].queryDocumentSnapshot.id ==
                widget.home.queryDocumentSnapshot.id) {
              setState(() {
                sDT = DateTime.parse(
                    sched[s].queryDocumentSnapshot.get('schedule_DateTime'));
              });
            }
          }
        }
      }
    }
    getExerciseData();
  }

  @override
  void initState() {
    getId();
    getScheduleData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.02,
          right: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.height * 0.02,
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutPreviewScreen(
                  home: widget.home,
                  title: title ?? '',
                  video: video ?? '',
                  exerciseTime: time ?? '',
                ),
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * double.infinity,
            decoration: BoxDecoration(
              color: AppColors.neonYellowColor,
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.02,
              ),
            ),
            child: Center(
              child: Text(
                exerciseSelected == true
                    ? AppStrings.resumeWorkout
                    : AppStrings.start,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize0025,
                  fontFamily: AssetsFont.montserratBold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: exercise.isNotEmpty
          ? Stack(
              children: [
                SizedBox(
                  child: CachedNetworkImage(
                    imageUrl: widget.home.queryDocumentSnapshot.get('image'),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * double.infinity,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.height * 0.02,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.1,
                    color: AppColors.halfBlackColor,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.whiteColor,
                        size: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.03,
                  right: MediaQuery.of(context).size.height * 0.03,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.12,
                    color: AppColors.halfBlackColor,
                    child: IconButton(
                      onPressed: () {
                        if (widget.home.isSelected == true) {
                          setState(() {
                            widget.home.isSelected = false;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(widget.home.queryDocumentSnapshot.id)
                                .delete();
                          });
                        } else {
                          setState(() {
                            widget.home.isSelected = true;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(widget.home.queryDocumentSnapshot.id)
                                .set({
                              'exercises': widget.home.queryDocumentSnapshot
                                  .get('exercises'),
                              'title': widget.home.queryDocumentSnapshot
                                  .get('title'),
                              'subtitle': widget.home.queryDocumentSnapshot
                                  .get('subtitle'),
                              'image': widget.home.queryDocumentSnapshot
                                  .get('image'),
                            });
                          });
                        }
                      },
                      icon: Icon(
                        widget.home.isSelected == false
                            ? Icons.bookmark_border_rounded
                            : Icons.bookmark_rounded,
                        color: widget.home.isSelected == false
                            ? AppColors.whiteColor
                            : Colors.redAccent,
                        size: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.66,
                    width: MediaQuery.of(context).size.width * double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backGroundColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                            MediaQuery.of(context).size.height * 0.02),
                        topLeft: Radius.circular(
                            MediaQuery.of(context).size.height * 0.02),
                      ),
                    ),
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.home.queryDocumentSnapshot.get('title'),
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0025,
                          ),
                        ),
                        Text(
                          '${widget.home.queryDocumentSnapshot.get('subtitle')} | 30 Min',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratRegular,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0018,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width *
                              double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.lightBlackColor,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * 0.015),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDateTime();
                                },
                                icon: Icon(
                                  Icons.calendar_month_rounded,
                                  color: AppColors.whiteColor,
                                  size:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                              ),
                              Text(
                                AppStrings.scheduleWorkout,
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontFamily: AssetsFont.montserratRegular,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize0016,
                                ),
                              ),
                              Text(
                                DateFormat('MMM dd hh:mm a').format(sDT),
                                // DateFormat('M/d,hh:mm').format(sDT),
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontFamily: AssetsFont.montserratRegular,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize0014,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDateTime();
                                },
                                icon: Icon(
                                  Icons.navigate_next_rounded,
                                  color: AppColors.whiteColor,
                                  size:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          AppStrings.exercise,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize002,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width *
                              double.infinity,
                          child: ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: exercise.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: AppColors.lightBrownColor,
                                elevation: 3,
                                margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.02),
                                child: ListTile(
                                  leading: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height *
                                              0.2),
                                      child: CachedNetworkImage(
                                        imageUrl: exercise[index]
                                            ['exercise_image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    exercise[index]['exercise_title'],
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontFamily: AssetsFont.montserratRegular,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize002,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '00:${exercise[index]['exercise_time']}',
                                    style: TextStyle(
                                      color: AppColors.brownColor,
                                      fontFamily: AssetsFont.montserratRegular,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize0018,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      if (exercise[index]
                                              ['exercise_selected'] ==
                                          false) {
                                        setState(() {
                                          exerciseSelected = true;
                                          exercise[index]['exercise_selected'] =
                                              true;
                                          selectedExercises.add(exercise[index]
                                              ['exercise_selected']);
                                          title =
                                              exercise[index]['exercise_title'];
                                          video =
                                              exercise[index]['exercise_video'];
                                          time =
                                              exercise[index]['exercise_time'];
                                          debugPrint(
                                              "Selected Exercises : ${selectedExercises.length}");
                                          FirebaseFirestore.instance
                                              .collection('workout_progress')
                                              .doc(userId)
                                              .collection('progress_data')
                                              .doc(widget.home
                                                  .queryDocumentSnapshot.id)
                                              .set({
                                            'exercise_progress':
                                                selectedExercises.length /
                                                    exercise.length,
                                            'title': widget
                                                .home.queryDocumentSnapshot
                                                .get('title'),
                                            'subtitle': widget
                                                .home.queryDocumentSnapshot
                                                .get('subtitle'),
                                            'image': widget
                                                .home.queryDocumentSnapshot
                                                .get('image'),
                                            'exercises': exercise,
                                            'start_time':
                                                DateTime.now().toString(),
                                            'completed_time':
                                                DateTime.now().toString(),
                                          });
                                        });
                                      } else {
                                        setState(() {
                                          exerciseSelected = false;
                                          exercise[index]['exercise_selected'] =
                                              false;
                                          selectedExercises.clear();
                                          for (int i = 0;
                                              i < exercise.length;
                                              i++) {
                                            if (exercise[i]
                                                    ['exercise_selected'] ==
                                                true) {
                                              setState(() {
                                                selectedExercises.add(
                                                    exercise[index]
                                                        ['exercise_selected']);
                                              });
                                            }
                                          }
                                          debugPrint(
                                              "Selected Exercises : ${selectedExercises.length}");
                                          FirebaseFirestore.instance
                                              .collection('workout_progress')
                                              .doc(userId)
                                              .collection('progress_data')
                                              .doc(widget.home
                                                  .queryDocumentSnapshot.id)
                                              .update({
                                            'exercise_progress':
                                                selectedExercises.length /
                                                    exercise.length,
                                            'exercises': exercise,
                                          });
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      exercise[index]['exercise_selected'] ==
                                              true
                                          ? Icons.check_circle_rounded
                                          : Icons.navigate_next_rounded,
                                      color: exercise[index]
                                                  ['exercise_selected'] ==
                                              true
                                          ? AppColors.neonYellowColor
                                          : AppColors.whiteColor,
                                      size: MediaQuery.of(context).size.height *
                                          0.03,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
