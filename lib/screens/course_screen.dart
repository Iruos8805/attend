import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:samplew/api.dart';
import 'package:samplew/screens/class_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  Future<List<Map<String, dynamic>>> fetchCourses() async {
    final response = await http.get(
      Uri.parse('https://group4attendance.pythonanywhere.com/api/courses/'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((courseEntry) => {
        'id': courseEntry['id'],
        'course_name': courseEntry['course_name'].toString(),
      }).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }


  Future<void> deleteCourse(int courseId) async {
    final response = await http.delete(
      Uri.parse('https://group4attendance.pythonanywhere.com/api/courses/$courseId/'),
    );

    if (response.statusCode == 204) {
      print('Course deleted');
    } else {
      print('Failed ${response.statusCode}');
    }
  }

  
Future<void> postcourses(String className) async {
  final response = await http.post(
    Uri.parse('https://group4attendance.pythonanywhere.com/api/courses/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'course_name': className,
    }),
  );

  if (response.statusCode == 201) {
    print('Course added');
  } else {
    print('Failed ${response.statusCode}');
  }
}


  void _createClass() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Class"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Class Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String className = _controller.text;
                postcourses(className);
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _createClass,
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No courses yet.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClassScreen(courseId: snapshot.data![index]['id']),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 25),
                            padding: EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data![index]['course_name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteCourse(snapshot.data![index]['id']);
                                    print('Delete ${snapshot.data![index]['course_name']}');
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
