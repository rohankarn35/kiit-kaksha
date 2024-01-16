import 'package:flutter/material.dart';
import 'package:kiit_kaksha/select.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dialogbox/showdeveloper.dart';
// import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late String section1 = "";
  late String section2 = "";
  late String section3 = "";

  void getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      section1 = prefs.getString("dropdownValue1") ?? " ";
      section2 = prefs.getString("dropdownValue2") ?? " ";
      section3 = prefs.getString("dropdownValue3") ?? " ";
    });
  }

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
         iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.black,
        // title: Text('About Us'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage("assets/logo.png"),
                      backgroundColor: Color.fromARGB(255, 9, 148, 14),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'KIIT ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          TextSpan(
                            text: 'KAKSHA',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Core Section: $section1',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Department Elective 1: $section2',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Department Elective 2: $section3',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 40),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildAboutContainer(
                            context,
                            'About Developer',
                            'Get to know about the developer',
                            () {
                              // Handle the action to show developer information
                              showDeveloperDialog(context);
                            },
                            Colors.black,
                          ),
                          const SizedBox(width: 10),
                          buildResetContainer(
                            context,
                            'Reset',
                            'Reset to change year and section again',
                            () {
                              // Handle the action to reset
                              showResetConfirmationDialog(context);
                            },
                            Colors.black,
                          ),
                          const SizedBox(width: 10),
                          buildReportContainer(
                            context,
                            'Report Problem',
                            'Report any issues',
                            () {
                              // Handle the action to report a problem
                              showReportDialog(context);
                            },
                            Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black,
            child: const Text(
              '© 2024 KIIT Connect',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAboutContainer(
      BuildContext context, String title, String subtitle, VoidCallback onPressed, Color color) {
    return Container(
      height: 110,
      width: 200,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white70,
              width: 1,
            ),
            color: color,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResetContainer(
      BuildContext context, String title, String subtitle, VoidCallback onPressed, Color color) {
    return Container(
      height: 110,
      width: 200,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white70,
              width: 1,
            ),
            color: color,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReportContainer(
      BuildContext context, String title, String subtitle, VoidCallback onPressed, Color color) {
    return Container(
      height: 110,
      width: 200,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white70,
              width: 1,
            ),
            color: color,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the developer information dialog


  void showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you really want to clear your data?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await clearLocalData();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BranchSelect()));
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> clearLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report Problem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please mail your problem to rohankarn35@gmail.com or connectkiit@gmail.com'),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
