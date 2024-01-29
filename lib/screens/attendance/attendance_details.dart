import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

class AttendanceDetail {
  final int courseId;
  final int classId;
  final int hourId;
  final String date;
  final String uid;
  final String name;

  AttendanceDetail({
    required this.courseId,
    required this.classId,
    required this.hourId,
    required this.date,
    required this.uid,
    required this.name,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDetail(
      courseId: json['course_id'],
      classId: json['class_id'],
      hourId: json['hour_id'],
      date: json['date'],
      uid: json['uid'],
      name: json['name'],
    );
  }
}


class AttendanceList extends StatefulWidget {
  final int courseId;
  final int classId;
  final int hourId;


  AttendanceList({
    required this.courseId,
    required this.classId,
    required this.hourId,
  });
  
  @override
  _AttendanceListState createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  late Future<List<AttendanceDetail>> _fetchAttendanceDetails;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceDetails = fetchAttendanceDetails();
  }

  Future<List<AttendanceDetail>> fetchAttendanceDetails() async {
    int courseId=widget.courseId;
    int classId=widget.classId;
    int hourId=widget.hourId;


    final response = await http.get(
      Uri.parse('https://group4attendance.pythonanywhere.com/api/courses/$courseId/classes/$classId/hours/$hourId/attendance'));
      
      if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<AttendanceDetail> attendanceDetails = data
          .map((item) => AttendanceDetail.fromJson(item))
          .where((detail) =>
              detail.courseId == widget.courseId &&
              detail.classId == widget.classId &&
              detail.hourId == widget.hourId)
          .toList();
      return attendanceDetails;
    } else {
      throw Exception('Failed to load attendance details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details'),
      ),
      body: FutureBuilder<List<AttendanceDetail>>(
        future: _fetchAttendanceDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No attendance details found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                AttendanceDetail attendanceDetail = snapshot.data![index];
                return ListTile(
                  title: Text('${attendanceDetail.date}'),
                  subtitle: Text(
                      'UID: ${attendanceDetail.uid}, \nName: ${attendanceDetail.name}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}