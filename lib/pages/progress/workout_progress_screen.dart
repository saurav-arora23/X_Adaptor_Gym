import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/models/workout_model.dart';
import 'package:x_adaptor_gym/pages/homepage/workout_screen.dart';

class WorkoutProgressScreen extends StatefulWidget {
  const WorkoutProgressScreen({super.key});

  @override
  State<WorkoutProgressScreen> createState() => _WorkoutProgressScreenState();
}

class _WorkoutProgressScreenState extends State<WorkoutProgressScreen> {
  ScrollController scrollController = ScrollController();

  String? userId;
  String? dropDownValue = "Annually";

  var items = ['Annually', 'Monthly', 'Weekly'];

  List<String> days = [];
  List<String> daysAsc = [];
  List<String> months = [];
  List<String> monthsAsc = [];
  List<String> years = [];
  List<String> yearsAsc = [];
  List<double> values = [];

  List<ChartData> monthly = [];
  List<ChartData> annually = [];
  List<ChartData> weekly = [];

  List<WorkoutModel> likedPost = [];
  List<WorkoutModel> startWorkout = [];

  @override
  void initState() {
    getId();
    getLikedData();
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
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppStrings.workoutProgressPageTitle,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: AssetsFont.montserratBold,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize0026,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.045,
                  width: MediaQuery.of(context).size.width * 0.24,
                  decoration: BoxDecoration(
                    color: AppColors.neonYellowColor,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.01),
                  ),
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.003),
                  child: DropdownButton(
                    isExpanded: true,
                    focusColor: AppColors.neonYellowColor,
                    dropdownColor: AppColors.neonYellowColor,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.01),
                    value: dropDownValue ?? "",
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.003),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String? items) {
                      return DropdownMenuItem(
                        value: items ?? "",
                        child: Text(
                          items ?? "",
                          style: TextStyle(
                            fontFamily: AssetsFont.montserratRegular,
                            color: AppColors.blackColor,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0014,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.014),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * double.infinity,
              color: AppColors.whiteColor,
              child: dropDownValue == "Weekly"
                  ? forWeekly()
                  : dropDownValue == "Monthly"
                      ? forMonthly()
                      : forAnnually(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            startWorkout.isNotEmpty
                ? Text(
                    AppStrings.latestWorkout,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontFamily: AssetsFont.montserratBold,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize0026,
                    ),
                  )
                : const SizedBox(),
            startWorkout.isNotEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(),
            startWorkout.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.47,
                    width: MediaQuery.of(context).size.width * double.infinity,
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: startWorkout.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WorkoutScreen(home: startWorkout[index]),
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
                                bottom:
                                    MediaQuery.of(context).size.height * 0.02),
                            elevation: 5,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          0.01),
                                  child: CachedNetworkImage(
                                    imageUrl: startWorkout[index]
                                        .queryDocumentSnapshot
                                        .get('image'),
                                    fit: BoxFit.fill,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width: MediaQuery.of(context).size.width *
                                        double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: MediaQuery.of(context).size.height * 0,
                                  right: MediaQuery.of(context).size.height * 0,
                                  child: IconButton(
                                    onPressed: () {
                                      if (startWorkout[index].isSelected ==
                                          true) {
                                        setState(() {
                                          startWorkout[index].isSelected =
                                              false;
                                          FirebaseFirestore.instance
                                              .collection('liked_workout')
                                              .doc(userId)
                                              .collection('workout_data')
                                              .doc(startWorkout[index]
                                                  .queryDocumentSnapshot
                                                  .id)
                                              .delete();
                                        });
                                      } else {
                                        setState(() {
                                          startWorkout[index].isSelected = true;
                                          FirebaseFirestore.instance
                                              .collection('liked_workout')
                                              .doc(userId)
                                              .collection('workout_data')
                                              .doc(startWorkout[index]
                                                  .queryDocumentSnapshot
                                                  .id)
                                              .set({
                                            'title': startWorkout[index]
                                                .queryDocumentSnapshot
                                                .get('title'),
                                            'subtitle': startWorkout[index]
                                                .queryDocumentSnapshot
                                                .get('subtitle'),
                                            'image': startWorkout[index]
                                                .queryDocumentSnapshot
                                                .get('image'),
                                            'exercises': startWorkout[index]
                                                .queryDocumentSnapshot
                                                .get('exercises'),
                                          });
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      startWorkout[index].isSelected == false
                                          ? Icons.bookmark_border_rounded
                                          : Icons.bookmark_rounded,
                                      color: startWorkout[index].isSelected ==
                                              false
                                          ? AppColors.whiteColor
                                          : Colors.redAccent,
                                      size: MediaQuery.of(context).size.height *
                                          0.04,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.06,
                                  left:
                                      MediaQuery.of(context).size.height * 0.02,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: startWorkout[index]
                                              .queryDocumentSnapshot
                                              .get('title'),
                                          style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontFamily:
                                                AssetsFont.montserratBold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                AppDimensions.fontSize0014,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n| ',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontFamily:
                                                AssetsFont.montserratBold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                AppDimensions.fontSize0014,
                                          ),
                                        ),
                                        TextSpan(
                                          text: startWorkout[index]
                                              .queryDocumentSnapshot
                                              .get('subtitle'),
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
                                Align(
                                  heightFactor:
                                      MediaQuery.of(context).size.height *
                                          0.0082,
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: LinearProgressIndicator(
                                      value: startWorkout[index]
                                          .queryDocumentSnapshot
                                          .get('exercise_progress'),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                      backgroundColor:
                                          AppColors.lightBlackColor,
                                      color: AppColors.neonYellowColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID') ?? '';
    // debugPrint("User Id is :- $userId");
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
    // debugPrint('Liked Data ${likedPost.length}');
    getProgressedWorkoutData();
  }

  getProgressedWorkoutData() async {
    QuerySnapshot<Map<String, dynamic>> snapShotData = await FirebaseFirestore
        .instance
        .collection('workout_progress')
        .doc(userId)
        .collection('progress_data')
        .get();
    if (snapShotData.toString().isNotEmpty) {
      for (int i = 0; i < snapShotData.docs.length; i++) {
        setState(() {
          startWorkout.add(WorkoutModel(
              queryDocumentSnapshot: snapShotData.docs[i], isSelected: false));
        });
        if (likedPost.isNotEmpty) {
          for (int l = 0; l < likedPost.length; l++) {
            if (likedPost[l].queryDocumentSnapshot.id ==
                snapShotData.docs[i].id) {
              setState(() {
                startWorkout[i].isSelected = true;
              });
            }
          }
        }
      }
    }
    // debugPrint("Start Workout Data ${startWorkout.length}");
    getDays();
  }

  getDays() {
    days.clear();
    int day = DateTime.now().day;
    for (int i = day; i > 0; i--) {
      if (days.length < 7) {
        setState(() {
          days.add((day).toString());
          day--;
        });
      } else {
        break;
      }
    }
    daysAsc.clear();
    for (int i = days.length - 1; i >= 0; i--) {
      setState(() {
        daysAsc.add(days[i]);
      });
    }
    // debugPrint('DaysAsc -- $daysAsc');
    getMonths();
  }

  getMonths() {
    months.clear();
    int month = DateTime.now().month;
    for (int i = month; i > 0; i--) {
      if (months.length < 7) {
        setState(() {
          months.add((month).toString());
          month--;
        });
      } else {
        break;
      }
    }
    monthsAsc.clear();
    for (int i = months.length - 1; i >= 0; i--) {
      setState(() {
        monthsAsc.add(months[i]);
      });
    }
    // debugPrint('MonthsAsc -- $monthsAsc');
    getYears();
  }

  getYears() {
    years.clear();
    int year = DateTime.now().year;
    for (int i = year; i > 0; i--) {
      if (years.length < 7) {
        setState(() {
          years.add((year).toString());
          year--;
        });
      } else {
        break;
      }
    }
    yearsAsc.clear();
    for (int i = years.length - 1; i >= 0; i--) {
      setState(() {
        yearsAsc.add(years[i]);
      });
    }
    // debugPrint('YearsAsc -- $yearsAsc');
    getWeeklyProgress();
  }

  getWeeklyProgress() {
    values.clear();
    weekly.clear();
    for (int i = 0; i < startWorkout.length; i++) {
      /*debugPrint("Day --- ${DateTime.parse(
          startWorkout[i].queryDocumentSnapshot.get('start_time'))
          .day
          .toString()}");*/
      for (int v = 0; v < daysAsc.length; v++) {
        if (daysAsc[v] ==
            DateTime.parse(
                    startWorkout[i].queryDocumentSnapshot.get('start_time'))
                .day
                .toString()) {
          debugPrint(
              "Day in if Condition --- ${DateTime.parse(startWorkout[i].queryDocumentSnapshot.get('start_time')).day.toString()}");
          weekly.add(ChartData(
              daysAsc[v],
              double.parse((DateTime.parse(startWorkout[i]
                          .queryDocumentSnapshot
                          .get('completed_time'))
                      .difference(DateTime.parse(startWorkout[i]
                          .queryDocumentSnapshot
                          .get('start_time')))
                      .inSeconds)
                  .toString())));
          // debugPrint('$weekly');
        } else {
          setState(() {
            weekly.add(ChartData(daysAsc[v], 0.0));
          });
        }
      }
    }
    debugPrint("Weekly Length -- ${weekly.length}");
    for (int i = 0; i < weekly.length; i++) {
      debugPrint("Weekly -- ${weekly[i].x} -- ${weekly[i].y}");
      // if (weekly[i].x = weekly[i + 1].x) {
      if (weekly[i].x == weekly[i + 1].x) {
        weekly[i].y = weekly[i].y + weekly[i + 1].y;
        debugPrint("Weekly Value X -- ${weekly[i].x} and Y ${weekly[i].y}");
        weekly.removeAt(i + 1);
        setState(() {});
        // }
      } else {
        break;
      }
    }
    debugPrint("Weekly -- ${weekly.length}");
    getMonthlyProgress();
  }

  getMonthlyProgress() {
    values.clear();
    monthly.clear();
    for (int i = 0; i < startWorkout.length; i++) {
      for (int v = 0; v < monthsAsc.length; v++) {
        if (monthsAsc[v].toString().contains(DateTime.parse(
                startWorkout[i].queryDocumentSnapshot.get('start_time'))
            .month
            .toString())) {
          monthly.add(ChartData(
              monthsAsc[v],
              double.parse((DateTime.parse(startWorkout[i]
                          .queryDocumentSnapshot
                          .get('completed_time'))
                      .difference(DateTime.parse(startWorkout[i]
                          .queryDocumentSnapshot
                          .get('start_time')))
                      .inMinutes)
                  .toString())));
        } else {
          monthly.add(ChartData(monthsAsc[v], 0.0));
        }
      }
      setState(() {});
    }
    debugPrint("Monthly Length -- ${monthly.length}");
    for (int i = 0; i < monthly.length; i++) {
      debugPrint("Monthly -- ${monthly[i].x} -- ${monthly[i].y}");
      // if (weekly[i].x = weekly[i + 1].x) {
      if (monthly[i].x == monthly[i + 1].x) {
        monthly[i].y = monthly[i].y + monthly[i + 1].y;
        debugPrint("Weekly Value X -- ${monthly[i].x} and Y ${monthly[i].y}");
        monthly.removeAt(i + 1);
        setState(() {});
        // }
      } else {
        break;
      }
    }
    debugPrint("Monthly -- ${monthly.length}");
    getAnnuallyProgress();
  }

  getAnnuallyProgress() {
    values.clear();
    annually.clear();
    for (int i = 0; i < startWorkout.length; i++) {
      for (int v = 0; v < yearsAsc.length; v++) {
        if (yearsAsc[v].toString().contains(DateTime.parse(
                startWorkout[i].queryDocumentSnapshot.get('start_time'))
            .year
            .toString())) {
          annually.add(ChartData(
              yearsAsc[v],
              double.parse((DateTime.parse(startWorkout[i]
                          .queryDocumentSnapshot
                          .get('completed_time'))
                      .difference(DateTime.parse(startWorkout[i]
                          .queryDocumentSnapshot
                          .get('start_time')))
                      .inHours)
                  .toString())));
        } else {
          annually.add(ChartData(yearsAsc[v], 0.0));
        }
      }
      setState(() {});
    }
    debugPrint("Annually Length -- ${annually.length}");
    for (int i = 0; i < annually.length; i++) {
      debugPrint("Annually -- ${annually[i].x} -- ${annually[i].y}");
      // if (weekly[i].x = weekly[i + 1].x) {
      if (annually[i].x == annually[i + 1].x) {
        annually[i].y = annually[i].y + annually[i + 1].y;
        debugPrint(
            "Annually Value X -- ${annually[i].x} and Y ${annually[i].y}");
        annually.removeAt(i + 1);
        setState(() {});
        // }
      } else {
        break;
      }
    }
    debugPrint("Annually -- ${annually.length}");
  }

  forWeekly() {
    return SfCartesianChart(
      plotAreaBackgroundColor: AppColors.backGroundColor,
      borderColor: AppColors.backGroundColor,
      backgroundColor: AppColors.backGroundColor,
      plotAreaBorderColor: AppColors.backGroundColor,
      primaryYAxis: CategoryAxis(
        isVisible: true,
        labelStyle: TextStyle(
            color: AppColors.whiteColor,
            fontSize: MediaQuery.of(context).size.height * 0.018,
            fontFamily: AssetsFont.montserratRegular),
      ),
      series: <CartesianSeries<ChartData, String>>[
        // Renders column chart
        ColumnSeries<ChartData, String>(
            animationDuration: 0,
            animationDelay: 0,
            isTrackVisible: false,
            trackColor: AppColors.lightBlackColor,
            color: AppColors.neonYellowColor,
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.05),
            dataSource: weekly,
            xValueMapper: (ChartData data, dynamic) => data.x,
            yValueMapper: (ChartData data, dynamic) => data.y)
      ],
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(
            color: AppColors.whiteColor,
            fontSize: MediaQuery.of(context).size.height * 0.018,
            fontFamily: AssetsFont.montserratRegular),
        isVisible: true,
      ),
    );
  }

  forMonthly() {
    return SfCartesianChart(
      plotAreaBackgroundColor: AppColors.backGroundColor,
      borderColor: AppColors.backGroundColor,
      backgroundColor: AppColors.backGroundColor,
      plotAreaBorderColor: AppColors.backGroundColor,
      primaryYAxis: CategoryAxis(
        isVisible: true,
        labelStyle: TextStyle(
            color: AppColors.whiteColor,
            fontSize: MediaQuery.of(context).size.height * 0.018,
            fontFamily: AssetsFont.montserratRegular),
      ),
      series: <CartesianSeries<ChartData, String>>[
        // Renders column chart
        ColumnSeries<ChartData, String>(
            animationDuration: 0,
            animationDelay: 0,
            isTrackVisible: false,
            trackColor: AppColors.lightBlackColor,
            color: AppColors.neonYellowColor,
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.05),
            dataSource: monthly,
            xValueMapper: (ChartData data, dynamic) => data.x,
            yValueMapper: (ChartData data, dynamic) => data.y)
      ],
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(
            color: AppColors.whiteColor,
            fontSize: MediaQuery.of(context).size.height * 0.018,
            fontFamily: AssetsFont.montserratRegular),
        isVisible: true,
      ),
    );
  }

  forAnnually() {
    return SfCartesianChart(
      plotAreaBackgroundColor: AppColors.backGroundColor,
      borderColor: AppColors.backGroundColor,
      backgroundColor: AppColors.backGroundColor,
      plotAreaBorderColor: AppColors.backGroundColor,
      primaryYAxis: CategoryAxis(
        isVisible: true,
        labelStyle: TextStyle(
            color: AppColors.whiteColor,
            fontSize: MediaQuery.of(context).size.height * 0.018,
            fontFamily: AssetsFont.montserratRegular),
      ),
      series: <CartesianSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
            animationDuration: 0,
            animationDelay: 0,
            isTrackVisible: false,
            trackColor: AppColors.lightBlackColor,
            color: AppColors.neonYellowColor,
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.05),
            dataSource: annually,
            xValueMapper: (ChartData data, dynamic) => data.x,
            yValueMapper: (ChartData data, dynamic) => data.y)
      ],
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(
            color: AppColors.whiteColor,
            fontSize: MediaQuery.of(context).size.height * 0.018,
            fontFamily: AssetsFont.montserratRegular),
        isVisible: true,
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  String x;
  double y;
}
