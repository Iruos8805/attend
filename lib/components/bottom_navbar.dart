import "package:flutter/material.dart";
import "package:samplew/screens/add_class_screen.dart";
import 'package:samplew/screens/attendance/attendance_details.dart';
import 'package:samplew/screens/course_screen.dart';
import 'package:samplew/screens/profile_screen.dart.dart';
import "package:samplew/screens/welcome_screen.dart";





class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_max_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.details), label: 'Attendance Details'),
        BottomNavigationBarItem(icon: Icon(Icons.account_box_rounded), label: 'Profile'),

      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseScreen(),),
          );
        } else {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(),),
          );
        }

      },
    );
  }
}
