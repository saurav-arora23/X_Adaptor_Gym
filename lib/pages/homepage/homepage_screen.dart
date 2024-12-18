import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/models/workout_model.dart';
import 'package:x_adaptor_gym/pages/homepage/notification_screen.dart';
import 'package:x_adaptor_gym/pages/homepage/see_all_screen.dart';
import 'package:x_adaptor_gym/pages/homepage/workout_screen.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<WorkoutModel> beginner = [];
  List<WorkoutModel> intermediate = [];
  List<WorkoutModel> advance = [];
  List<WorkoutModel> newWorkout = [];
  List<WorkoutModel> likedPost = [];
  List<WorkoutModel> completedWorkout = [];
  List<WorkoutModel> todayWorkout = [];
  List<WorkoutModel> result = [];

  List<QueryDocumentSnapshot> notification = [];

  bool isSearching = false;
  int selectedIndex = 0;
  DateTime todayTime = DateTime.now();
  String? userId;

  @override
  void initState() {
    getId();
    getLikedData();
    getNotificationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        surfaceTintColor: AppColors.backGroundColor,
        toolbarHeight: MediaQuery.of(context).size.height * 0.02,
      ),
      body: beginner.isEmpty || intermediate.isEmpty || advance.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.02,
                right: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          AppStrings.homePageTitle,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0030,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                        icon: notification.isEmpty
                            ? Icon(
                                Icons.notifications_rounded,
                                color: AppColors.whiteColor,
                                size: MediaQuery.of(context).size.height * 0.04,
                              )
                            : Stack(
                                children: [
                                  Icon(
                                    Icons.notifications_rounded,
                                    color: AppColors.whiteColor,
                                    size: MediaQuery.of(context).size.height *
                                        0.04,
                                  ),
                                  Positioned(
                                    top: MediaQuery.of(context).size.height *
                                        0.008,
                                    right: MediaQuery.of(context).size.height *
                                        0.008,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.012,
                                      width: MediaQuery.of(context).size.width *
                                          0.025,
                                      decoration: BoxDecoration(
                                        color: AppColors.darkOrangeColor,
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.height *
                                                0.025),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightBlackColor,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.015),
                    ),
                    child: TextFormField(
                      onChanged: (v) {
                        result.clear();
                        isSearching = true;
                        for (int i = 0; i < beginner.length; i++) {
                          if (beginner[i]
                              .queryDocumentSnapshot
                              .get('title')
                              .toString()
                              .toLowerCase()
                              .contains(v)) {
                            result.add(beginner[i]);
                          }
                        }
                        if (v.isEmpty) {
                          isSearching = false;
                        }
                        setState(() {});
                      },
                      controller: searchController,
                      cursorColor: AppColors.whiteColor,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: AppColors.blackColor,
                            size: MediaQuery.of(context).size.height * 0.024),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: AssetsFont.montserratRegular,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize0015,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  result.isNotEmpty && isSearching == false
                      ? const SizedBox()
                      : isSearching == true && result.isEmpty
                          ? Center(
                              child: Text(
                                'No Search Found !!',
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize002,
                                  fontFamily: AssetsFont.montserratBold,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: result.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WorkoutScreen(home: result[index]),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: AppColors.backGroundColor,
                                    surfaceTintColor: AppColors.backGroundColor,
                                    elevation: 2,
                                    margin: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          child: CachedNetworkImage(
                                            imageUrl: result[index]
                                                .queryDocumentSnapshot
                                                .get('image'),
                                            fit: BoxFit.fill,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0,
                                          child: IconButton(
                                            onPressed: () {
                                              if (result[index].isSelected ==
                                                  false) {
                                                setState(() {
                                                  result[index].isSelected =
                                                      true;
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'liked_workout')
                                                      .doc(userId)
                                                      .collection(
                                                          'workout_data')
                                                      .doc(result[index]
                                                          .queryDocumentSnapshot
                                                          .id)
                                                      .set({
                                                    'title': result[index]
                                                        .queryDocumentSnapshot
                                                        .get('title'),
                                                    'subtitle': result[index]
                                                        .queryDocumentSnapshot
                                                        .get('subtitle'),
                                                    'image': result[index]
                                                        .queryDocumentSnapshot
                                                        .get('image'),
                                                  });
                                                });
                                              } else {
                                                setState(() {
                                                  result[index].isSelected =
                                                      false;
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'liked_workout')
                                                      .doc(userId)
                                                      .collection(
                                                          'workout_data')
                                                      .doc(result[index]
                                                          .queryDocumentSnapshot
                                                          .id)
                                                      .delete();
                                                });
                                              }
                                            },
                                            icon: Icon(
                                              result[index].isSelected == false
                                                  ? Icons
                                                      .bookmark_border_rounded
                                                  : Icons.bookmark_rounded,
                                              color: result[index].isSelected ==
                                                      false
                                                  ? AppColors.whiteColor
                                                  : Colors.redAccent,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.015,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: result[index]
                                                      .queryDocumentSnapshot
                                                      .get('title'),
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                    fontFamily: AssetsFont
                                                        .montserratBold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            AppDimensions
                                                                .fontSize0014,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '\n| ',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontFamily: AssetsFont
                                                        .montserratBold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            AppDimensions
                                                                .fontSize0014,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: result[index]
                                                      .queryDocumentSnapshot
                                                      .get('subtitle'),
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                    fontFamily: AssetsFont
                                                        .montserratRegular,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            AppDimensions
                                                                .fontSize0014,
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
                  isSearching == true
                      ? const SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            todayWorkout.isNotEmpty
                                ? Text(
                                    AppStrings.todayWorkoutPlan,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize002,
                                      fontFamily: AssetsFont.montserratBold,
                                    ),
                                  )
                                : const SizedBox(),
                            todayWorkout.isNotEmpty
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01)
                                : const SizedBox(),
                            todayWorkout.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height *
                                            0.008),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.23,
                                      width: MediaQuery.of(context).size.width *
                                          double.infinity,
                                      child: forTodayWorkout(context),
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.workoutCategories,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            AppDimensions.fontSize002,
                                    fontFamily: AssetsFont.montserratBold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SeeAllScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    AppStrings.seeAll,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize0018,
                                      fontFamily: AssetsFont.montserratBold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            CupertinoSlidingSegmentedControl(
                              children: {
                                0: Text(
                                  AppStrings.beginner,
                                  style: TextStyle(
                                    color: selectedIndex == 0
                                        ? AppColors.blackColor
                                        : AppColors.whiteColor,
                                    fontFamily: AssetsFont.montserratBold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
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
                                    fontSize:
                                        MediaQuery.of(context).size.height *
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
                                    fontSize:
                                        MediaQuery.of(context).size.height *
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
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.008),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                width: MediaQuery.of(context).size.width *
                                    double.infinity,
                                child: selectedIndex == 0
                                    ? forBeginner(context)
                                    : selectedIndex == 1
                                        ? forIntermediate(context)
                                        : forAdvance(context),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Text(
                              AppStrings.newWorkouts,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize002,
                                fontFamily: AssetsFont.montserratBold,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.008),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                width: MediaQuery.of(context).size.width *
                                    double.infinity,
                                child: forNewWorkout(context),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                          ],
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
    }
    debugPrint("Beginner Data -- ${beginner.length}");
    getIntermediateData();
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
    }
    debugPrint("Intermediate Data -- ${intermediate.length}");
    getAdvanceData();
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
    }
    debugPrint("Advance Data -- ${advance.length}");
    getNewWorkoutData();
  }

  getNewWorkoutData() async {
    QuerySnapshot<Map<String, dynamic>> snapShotData =
        await FirebaseFirestore.instance.collection('new_workouts').get();
    if (snapShotData.toString().isNotEmpty) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          newWorkout.add(WorkoutModel(
              queryDocumentSnapshot: snapShotData.docs[i], isSelected: false));
        });
        if (likedPost.isNotEmpty) {
          for (int l = 0; l < likedPost.length; l++) {
            if (likedPost[l].queryDocumentSnapshot.id ==
                snapShotData.docs[i].id) {
              setState(() {
                newWorkout[i].isSelected = true;
              });
            }
          }
        }
      }
    }
    debugPrint("New Workout Data -- ${newWorkout.length}");
    getTodayWorkoutData();
  }

  getTodayWorkoutData() async {
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('workout_progress')
        .doc(userId)
        .collection('progress_data')
        .get();
    if (snapShotData.toString().isNotEmpty) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          completedWorkout.add(WorkoutModel(
              queryDocumentSnapshot: snapShotData.docs[i], isSelected: false));
        });
        if (likedPost.isNotEmpty) {
          for (int l = 0; l < likedPost.length; l++) {
            if (likedPost[l].queryDocumentSnapshot.id ==
                snapShotData.docs[i].id) {
              setState(() {
                completedWorkout[i].isSelected = true;
              });
            }
          }
        }
        if (DateTime.parse(
                    completedWorkout[i].queryDocumentSnapshot.get('start_time'))
                .day ==
            DateTime.now().day) {
          setState(() {
            todayWorkout.add(WorkoutModel(
                queryDocumentSnapshot:
                    completedWorkout[i].queryDocumentSnapshot,
                isSelected: completedWorkout[i].isSelected));
          });
        }
      }
    }
    debugPrint("Today Workout Data ${todayWorkout.length}");
  }

  getLikedData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
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
    }
    debugPrint('Liked Data ${likedPost.length}');
    getBeginnerData();
  }

  getNotificationData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('notifications')
        .doc(userId)
        .collection('notification_data')
        .get();
    if (snapShotData.toString().isNotEmpty) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          notification.add(snapShotData.docs[i]);
        });
      }
    }
    debugPrint("Notification Data -- ${notification.length}");
  }

  forBeginner(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
        autoPlay: false,
      ),
      items: beginner.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreen(home: i),
                  ),
                );
                if (result == true || result == null) {
                  setState(() {
                    getId();
                  });
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.01),
                    child: CachedNetworkImage(
                      imageUrl: i.queryDocumentSnapshot.get('image'),
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0,
                    right: MediaQuery.of(context).size.height * 0,
                    child: IconButton(
                      onPressed: () {
                        if (i.isSelected == true) {
                          setState(() {
                            i.isSelected = false;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(i.queryDocumentSnapshot.id)
                                .delete();
                          });
                        } else {
                          setState(() {
                            i.isSelected = true;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(i.queryDocumentSnapshot.id)
                                .set({
                              'title': i.queryDocumentSnapshot.get('title'),
                              'subtitle':
                                  i.queryDocumentSnapshot.get('subtitle'),
                              'image': i.queryDocumentSnapshot.get('image'),
                              'exercises':
                                  i.queryDocumentSnapshot.get('exercises'),
                            });
                          });
                        }
                      },
                      icon: Icon(
                        i.isSelected == false
                            ? Icons.bookmark_border_rounded
                            : Icons.bookmark_rounded,
                        color: i.isSelected == false
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
                            text: i.queryDocumentSnapshot.get('title'),
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
                            text: i.queryDocumentSnapshot.get('subtitle'),
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
            );
          },
        );
      }).toList(),
    );
  }

  forIntermediate(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
        autoPlay: false,
      ),
      items: intermediate.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreen(home: i),
                  ),
                );
                if (result == true || result == null) {
                  setState(() {
                    getId();
                  });
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.01),
                    child: CachedNetworkImage(
                      imageUrl: i.queryDocumentSnapshot.get('image'),
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0,
                    right: MediaQuery.of(context).size.height * 0,
                    child: IconButton(
                      onPressed: () {
                        if (i.isSelected == true) {
                          setState(() {
                            i.isSelected = false;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(i.queryDocumentSnapshot.id)
                                .delete();
                          });
                        } else {
                          setState(() {
                            i.isSelected = true;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(i.queryDocumentSnapshot.id)
                                .set({
                              'title': i.queryDocumentSnapshot.get('title'),
                              'subtitle':
                                  i.queryDocumentSnapshot.get('subtitle'),
                              'image': i.queryDocumentSnapshot.get('image'),
                              'exercises':
                                  i.queryDocumentSnapshot.get('exercises'),
                            });
                          });
                        }
                      },
                      icon: Icon(
                        i.isSelected == false
                            ? Icons.bookmark_border_rounded
                            : Icons.bookmark_rounded,
                        color: i.isSelected == false
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
                            text: i.queryDocumentSnapshot.get('title'),
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
                            text: i.queryDocumentSnapshot.get('subtitle'),
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
            );
          },
        );
      }).toList(),
    );
  }

  forAdvance(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
        autoPlay: false,
      ),
      items: advance.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreen(home: i),
                  ),
                );
                if (result == true || result == null) {
                  setState(() {
                    getId();
                  });
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.01),
                    child: CachedNetworkImage(
                      imageUrl: i.queryDocumentSnapshot.get('image'),
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0,
                    right: MediaQuery.of(context).size.height * 0,
                    child: IconButton(
                      onPressed: () {
                        if (i.isSelected == true) {
                          setState(() {
                            i.isSelected = false;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(i.queryDocumentSnapshot.id)
                                .delete();
                          });
                        } else {
                          setState(() {
                            i.isSelected = true;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(i.queryDocumentSnapshot.id)
                                .set({
                              'title': i.queryDocumentSnapshot.get('title'),
                              'subtitle':
                                  i.queryDocumentSnapshot.get('subtitle'),
                              'image': i.queryDocumentSnapshot.get('image'),
                              'exercises':
                                  i.queryDocumentSnapshot.get('exercises'),
                            });
                          });
                        }
                      },
                      icon: Icon(
                        i.isSelected == false
                            ? Icons.bookmark_border_rounded
                            : Icons.bookmark_rounded,
                        color: i.isSelected == false
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
                            text: i.queryDocumentSnapshot.get('title'),
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
                            text: i.queryDocumentSnapshot.get('subtitle'),
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
            );
          },
        );
      }).toList(),
    );
  }

  forNewWorkout(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
        autoPlay: false,
      ),
      items: newWorkout.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreen(home: i),
                  ),
                );
                if (result == true || result == null) {
                  setState(() {
                    getId();
                  });
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.01),
                    child: CachedNetworkImage(
                      imageUrl: i.queryDocumentSnapshot.get('image'),
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0,
                    right: MediaQuery.of(context).size.height * 0,
                    child: IconButton(
                      onPressed: () {
                        if (i.isSelected == true) {
                          setState(() {
                            i.isSelected = false;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(i.queryDocumentSnapshot.id)
                                .delete();
                          });
                        } else {
                          setState(() {
                            i.isSelected = true;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(i.queryDocumentSnapshot.id)
                                .set({
                              'title': i.queryDocumentSnapshot.get('title'),
                              'subtitle':
                                  i.queryDocumentSnapshot.get('subtitle'),
                              'image': i.queryDocumentSnapshot.get('image'),
                              'exercises':
                                  i.queryDocumentSnapshot.get('exercises'),
                            });
                          });
                        }
                      },
                      icon: Icon(
                        i.isSelected == false
                            ? Icons.bookmark_border_rounded
                            : Icons.bookmark_rounded,
                        color: i.isSelected == false
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
                            text: i.queryDocumentSnapshot.get('title'),
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
                            text: i.queryDocumentSnapshot.get('subtitle'),
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
            );
          },
        );
      }).toList(),
    );
  }

  forTodayWorkout(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
        autoPlay: false,
      ),
      items: todayWorkout.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreen(home: i),
                  ),
                );
                if (result == true || result == null) {
                  setState(() {
                    getId();
                  });
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.01),
                    child: CachedNetworkImage(
                      imageUrl: i.queryDocumentSnapshot.get('image'),
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0,
                    right: MediaQuery.of(context).size.height * 0,
                    child: IconButton(
                      onPressed: () {
                        if (i.isSelected == true) {
                          setState(() {
                            i.isSelected = false;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(i.queryDocumentSnapshot.id)
                                .delete();
                          });
                        } else {
                          setState(() {
                            i.isSelected = true;
                            FirebaseFirestore.instance
                                .collection('liked_workout')
                                .doc(userId)
                                .collection('workout_data')
                                .doc(i.queryDocumentSnapshot.id)
                                .set({
                              'title': i.queryDocumentSnapshot.get('title'),
                              'subtitle':
                                  i.queryDocumentSnapshot.get('subtitle'),
                              'image': i.queryDocumentSnapshot.get('image'),
                              'exercises':
                                  i.queryDocumentSnapshot.get('exercises'),
                            });
                          });
                        }
                      },
                      icon: Icon(
                        i.isSelected == false
                            ? Icons.bookmark_border_rounded
                            : Icons.bookmark_rounded,
                        color: i.isSelected == false
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
                            text: i.queryDocumentSnapshot.get('title'),
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
                            text: i.queryDocumentSnapshot.get('subtitle'),
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
            );
          },
        );
      }).toList(),
    );
  }
}
