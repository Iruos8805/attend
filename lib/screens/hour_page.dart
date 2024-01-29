import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:samplew/screens/QR_SCANNER_WITHBACK.dart';
import 'package:samplew/screens/attendance/attendance_details.dart';

class HourPage extends StatefulWidget {
  final int courseId;
  final int classId;

  const HourPage({Key? key, required this.courseId, required this.classId}) : super(key: key);

  @override
  _HourPageState createState() => _HourPageState();
}

class _HourPageState extends State<HourPage> {
  late Future<List<dynamic>> _fetchHours;
  late TextEditingController _hourController;

  @override
  void initState() {
    super.initState();
    _fetchHours = fetchHours(widget.courseId, widget.classId);
    _hourController = TextEditingController();
  }

  Future<List<dynamic>> fetchHours(int courseId, int classId) async {
    final response = await http.get(
      Uri.parse('https://group4attendance.pythonanywhere.com/api/courses/$courseId/classes/$classId/hours/'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load hours');
    }
  }

  Future<void> createHour(String hour) async {
    final courseId = widget.courseId;
    final classId = widget.classId;

    String formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ').format(DateTime.now());

    var response = await http.post(
      Uri.parse('https://group4attendance.pythonanywhere.com/api/courses/$courseId/classes/$classId/hours/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'course_id': courseId,
        'class_id': classId,
        'hour': hour,
        'time': formattedDateTime,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _fetchHours = fetchHours(widget.courseId, widget.classId);
      });
    } else {
      print('Failed to create hour: ${response.statusCode}');
    }
  }


  @override
  void dispose() {
    _hourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hours'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchHours,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hours found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]['hour']),
                  trailing: IconButton(
                    icon: Icon(Icons.qr_code),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanQRPage(courseId: widget.courseId,classId: widget.classId,hourId: snapshot.data![index]['id'],),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendanceList(
        courseId: widget.courseId,
        classId: widget.classId,
        hourId: snapshot.data![index]['id'],
      ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Hour'),
                content: TextField(
                  controller: _hourController,
                  decoration: InputDecoration(labelText: 'Hour Name'),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      createHour(_hourController.text);
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
