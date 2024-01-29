import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flip_card/flip_card.dart'; 
import 'package:random_string/random_string.dart';
import 'package:samplew/screens/app_bar.dart';
import 'package:samplew/screens/qr_code_generator.dart';

class StudentPage extends StatefulWidget {
  final String uid;

  const StudentPage({required this.uid});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  bool _showBack = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.lightGreen,
              Colors.black38,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 1),
              FlipCard(
                direction: FlipDirection.HORIZONTAL,
                flipOnTouch: true,
                front: _buildFront(),
                back: _buildBack(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 5.0),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/teacher.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 50),
        Text(
          'Click to view the QR code',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.merriweatherSans().fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildBack() {
    return InkWell(
      onTap: () {
        setState(() {
          _showBack = !_showBack;
        });
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.white, width: 2.0),
        ),
        child: QrImageView(
          data: widget.uid,
          size: 300,
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: Size(80, 80),
          ),
        ),
      ),
    );
  }
}
