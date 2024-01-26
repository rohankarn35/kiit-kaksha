import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kiit_kaksha/branch_select.dart';
import 'package:kiit_kaksha/branchwise/secondview.dart';
import 'package:kiit_kaksha/thirdyear/third_year_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    analytics.setAnalyticsCollectionEnabled(true);

    // Redirect to another page after a delay
    Timer(Duration(milliseconds: 800), _redirectToPage);
  }

  void _redirectToPage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String section1 = prefs.getString("dropdownValue1") ?? " ";
      String section2 = prefs.getString("dropdownValue2") ?? " ";
      String section3 = prefs.getString("dropdownValue3") ?? " ";
      String section4 = prefs.getString("dropdownValue4") ?? " ";

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            if (prefs.getBool('startFromSecondViewPage') ?? false) {
              return SecondYearViews(section1: section4);
            } else if (prefs.getBool('startFromViewPage') ?? false) {
              return Views(
                  section1: section1, section2: section2, section3: section3);
            } else {
              return BranchSelect();
            }
          },
        ),
      );
    } catch (e) {
      print('Error in _redirectToPage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    analytics
        .logEvent(name: 'splashscreen', parameters: {'splash': 'splashscreen'});

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 8),
            Image.asset("assets/logo.png", height: 150, width: 150),
            SizedBox(height: MediaQuery.of(context).size.height / 11),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'KIIT ',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  TextSpan(
                    text: 'KAKSHA',
                    style: TextStyle(
                      fontSize: 30,
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
