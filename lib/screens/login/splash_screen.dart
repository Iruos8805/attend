
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samplew/constants.dart';
import 'package:samplew/screens/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  
    Future.delayed(
      Duration(
        seconds: 3,
      ),
          () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kviolet, kpurple],
            begin: Alignment.topCenter,
            end: Alignment.topLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            Image.asset(
              "assets/icon/logout.png",
              width: 120,
              height: 120, 
            ),
            SizedBox(height: 16), 

            // Text below the logo
            Text(
              'Roll Call',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
