import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'hour_page.dart'; // Import the HourPage

class ClassScreen extends StatefulWidget {
  final int courseId;

  const ClassScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  late Future<List<dynamic>> _fetchClasses;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _fetchClasses = fetchClasses(widget.courseId);
    _controller = TextEditingController();
  }

  Future<List<dynamic>> fetchClasses(int courseId) async {
    final response = await http.get(
      Uri.parse('https://group4attendance.pythonanywhere.com/api/courses/$courseId/classes/'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load classes');
    }
  }

  Future<void> addClass(String className) async {
    final courseId = widget.courseId;

    final response = await http.post(
      Uri.parse('https://group4attendance.pythonanywhere.com/api/courses/$courseId/classes/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'class_name': className,
        'course_id': courseId,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _fetchClasses = fetchClasses(widget.courseId);
      });
      print('Class added');
    } else {
      print('Failed ${response.statusCode}');
    }
  }



  void _addClass() {
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
                addClass(className);
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHourPage(int classId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HourPage(courseId: widget.courseId, classId: classId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addClass,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchClasses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No classes found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]['class_name']),
                  onTap: () {
                    _navigateToHourPage(snapshot.data![index]['id'],
                    ); 
                  },
                  
                );
              },
            );
          }
        },
      ),
    );
  }
}
