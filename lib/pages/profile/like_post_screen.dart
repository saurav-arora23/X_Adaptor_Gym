import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/appStyle/app_dimensions.dart';
import 'package:x_adaptor_gym/appStyle/assets_font.dart';
import 'package:x_adaptor_gym/models/workout_model.dart';
import 'package:x_adaptor_gym/pages/homepage/workout_screen.dart';

class LikePostScreen extends StatefulWidget {
  const LikePostScreen({super.key});

  @override
  State<LikePostScreen> createState() => _LikePostScreenState();
}

class _LikePostScreenState extends State<LikePostScreen> {
  ScrollController scrollController = ScrollController();
  List<WorkoutModel> likedPost = [];
  String? userId;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    debugPrint("userId -- $userId");
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
        title: Text(
          'Like',
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
            size: MediaQuery.of(context).size.height * 0.035,
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.15,
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.height * 0.01,
          right: MediaQuery.of(context).size.height * 0.01,
        ),
        child: likedPost.isNotEmpty
            ? ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: likedPost.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkoutScreen(home: likedPost[index]),
                        ),
                      );
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
                              imageUrl: likedPost[index]
                                  .queryDocumentSnapshot
                                  .get('image'),
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width *
                                  double.infinity,
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0,
                            right: MediaQuery.of(context).size.height * 0,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  likedPost[index].isSelected = false;
                                  FirebaseFirestore.instance
                                      .collection('liked_workout')
                                      .doc(userId)
                                      .collection('workout_data')
                                      .doc(likedPost[index]
                                          .queryDocumentSnapshot
                                          .id)
                                      .delete();
                                });
                                likedPost.removeAt(index);
                              },
                              icon: Icon(
                                likedPost[index].isSelected == true
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                color: likedPost[index].isSelected == true
                                    ? Colors.redAccent
                                    : Colors.white,
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
                                    text: likedPost[index]
                                        .queryDocumentSnapshot
                                        .get('title'),
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontFamily: AssetsFont.montserratBold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize0014,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n| ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: AssetsFont.montserratBold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize0014,
                                    ),
                                  ),
                                  TextSpan(
                                    text: likedPost[index]
                                        .queryDocumentSnapshot
                                        .get('subtitle'),
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontFamily: AssetsFont.montserratRegular,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
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
              )
            : Center(
                child: Text(
                  "You Don't Liked Any Post Yet",
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontFamily: AssetsFont.montserratBold,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize0022),
                ),
              ),
      ),
    );
  }
}
