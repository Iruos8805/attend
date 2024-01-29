import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRPage extends StatefulWidget {
  final int courseId;
  final int classId;
  final int hourId;

  const ScanQRPage({Key? key, required this.courseId, required this.classId, required this.hourId}) : super(key: key);

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  String? scannedResult;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> postScannedResult(String result) async {
    final courseId=widget.courseId;
    final classId=widget.classId;
    final hourId=widget.hourId;


    var response = await http.post(
      Uri.parse('https://group4attendance.pythonanywhere.com/api/courses/$courseId/classes/$classId/hours/$hourId/attendance'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'special_uid': result,
        'course_id':courseId,
        'class_id':classId,
        'hour_id':hourId,
      }),
    );

    if (response.statusCode == 201) {
      print('Success');
        } else {
      print('Failed to post scanned result: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    scannedResult = scanData.code;
                  });
                  postScannedResult(scanData.code.toString());
                });
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Scanned Result: ${scannedResult ?? 'No result yet'}',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
