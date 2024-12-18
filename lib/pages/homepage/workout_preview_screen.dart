import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/app_strings.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/models/workout_model.dart';
import 'package:x_adaptor_gym/pages/common_function.dart';

class WorkoutPreviewScreen extends StatefulWidget {
  WorkoutPreviewScreen(
      {super.key,
      required this.home,
      required this.title,
      required this.video,
      required this.exerciseTime});
  WorkoutModel home;
  String title;
  String video;
  String exerciseTime;

  @override
  State<WorkoutPreviewScreen> createState() => _WorkoutPreviewScreenState();
}

class _WorkoutPreviewScreenState extends State<WorkoutPreviewScreen> {
  late Timer _timer;
  int _start = 0;
  bool play = false;
  bool finish = false;
  bool sec = false;
  String? userId;

  VideoPlayerController? playerController;

  startTimer(int seconds) {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (seconds == 0) {
          setState(() {
            finish = true;
            play = false;
            stopVideo();
            _timer.cancel();
          });
        } else {
          setState(() {
            seconds--;
            _start = seconds;
          });
        }
        if (seconds < 10) {
          setState(() {
            sec = true;
          });
        }
      },
    );
  }

  stopTimer() {
    setState(() {
      _timer.cancel();
    });
  }

  startVideo() {
    setState(() {
      play = true;
      playerController!.play();
      playerController!.setLooping(true);
    });
    startTimer(_start);
  }

  stopVideo() {
    setState(() {
      play = false;
      playerController!.pause();
      playerController!.setLooping(false);
    });
    stopTimer();
  }

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    debugPrint('User Id is:-$userId');
  }

  @override
  void initState() {
    getId();
    _start = int.parse(widget.exerciseTime);
    playerController = VideoPlayerController.networkUrl(Uri.parse(widget.video))
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
            finish == false
                ? setState(() {
                    startVideo();
                  })
                : showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext dialogContext) =>
                        CommonFunction.dialogBox(context, userId!, widget.home),
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
                finish == false ? AppStrings.next : AppStrings.finish,
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
      body: playerController == null
          ? const SizedBox()
          : Stack(
              children: [
                /*SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width * double.infinity,
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 6 / 9,
                        child: VideoPlayer(playerController!),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: play == false
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    startVideo();
                                    play = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    stopVideo();
                                    play = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),*/
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
                  top: MediaQuery.of(context).size.height * 0.04,
                  right: MediaQuery.of(context).size.height * 0.175,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontFamily: AssetsFont.lexendDecaSemiBold,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize002,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.scoredTime,
                          style: TextStyle(
                            color: AppColors.lightBlackColor,
                            fontFamily: AssetsFont.montserratRegular,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0016,
                          ),
                        ),
                        Center(
                          child: Text(
                            sec == false ? '00:$_start' : '00:0$_start',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontFamily: AssetsFont.montserratRegular,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize0060,
                            ),
                          ),
                        ),
                        Text(
                          '4x repts',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AssetsFont.montserratBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize0022,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
