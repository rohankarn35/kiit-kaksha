import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kiit_kaksha/branchwise/secondview.dart';
import 'package:kiit_kaksha/list.dart';
import 'package:kiit_kaksha/select.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showAnimation = false;

  @override
  void initState() {
    super.initState();
    analytics.setAnalyticsCollectionEnabled(true);

    // Start the animation after a delay
    Timer(Duration(milliseconds: 400), () {
      setState(() {
        showAnimation = true;
      });

      // Redirect to another page after 3 seconds
      Timer(Duration(milliseconds: 800), () {
        _redirectToPage();
      });
    });
  }

void _redirectToPage() async {
  try {
    // Check shared preferences values
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool startFromViewPage = prefs.getBool('startFromViewPage') ?? false;
    bool startFromSecondViewPage = prefs.getBool('startFromSecondViewPage') ?? false;
    String section1 = prefs.getString("dropdownValue1") ?? " ";
    String section2 = prefs.getString("dropdownValue2") ?? " ";
    String section3 = prefs.getString("dropdownValue3") ?? " ";
    String section4 = prefs.getString("dropdownValue4") ?? " ";

    // Decide where to navigate
    if (startFromSecondViewPage) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SecondYearViews(
            section1: section4,
          ),
        ),
      );
    } else if (startFromViewPage) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Views(
            section1: section1,
            section2: section2,
            section3: section3,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BranchSelect(),
        ),
      );
    }
  } catch (e) {
    // Handle exceptions here
    print('Error in _redirectToPage: $e');
    // You can show an error message to the user or take other appropriate actions
  }
}
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  @override
  Widget build(BuildContext context) {
            analytics.logEvent(name: 'splashscreen', parameters: {'splash': 'splashscreen'});

    return Scaffold(
      
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            AnimatedContainer(
              duration: Duration(seconds: 1),
              height: showAnimation ? 120 : 0,
              width: showAnimation ? 120 : 0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 9, 148, 14),
              ),
              child: showAnimation
                  ? Image.asset("assets/logo.png", fit: BoxFit.cover)
                  : null,
            ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'KIIT ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  TextSpan(
                    text: 'KAKSHA',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
