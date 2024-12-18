import 'package:flutter/material.dart';
import 'package:x_adaptor_gym/appStyle/app_colors.dart';
import 'package:x_adaptor_gym/pages/homepage/homepage_screen.dart';
import 'package:x_adaptor_gym/pages/profile/profile_screen.dart';
import 'package:x_adaptor_gym/pages/progress/workout_progress_screen.dart';
import 'package:x_adaptor_gym/pages/schedule/scheduled_workouts_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = [
    const HomepageScreen(),
    const WorkoutProgressScreen(),
    const ScheduledWorkoutsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.backGroundColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.home_filled,
                size: MediaQuery.of(context).size.height * 0.04,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.auto_graph_rounded,
                size: MediaQuery.of(context).size.height * 0.04,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.calendar_today,
                size: MediaQuery.of(context).size.height * 0.04,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.person_outline_rounded,
                size: MediaQuery.of(context).size.height * 0.045,
              ),
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.lightNeonYellowColor,
          unselectedItemColor: AppColors.darkWhiteColor,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
