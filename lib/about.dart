import 'package:flutter/material.dart';
import 'package:kiit_kaksha/aboutwidgets/showconfirmation.dart';
import 'package:kiit_kaksha/aboutwidgets/showremainder.dart';
import 'package:kiit_kaksha/aboutwidgets/showreport.dart';
import 'package:kiit_kaksha/provider/thirdyearselect.dart';
import 'package:kiit_kaksha/widgets/aboutwidget.dart';

import 'package:provider/provider.dart';

import 'dialogbox/showdeveloper.dart';

class AboutPage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> weeklySchedule; 
   AboutPage({Key? key, required this.weeklySchedule}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String section1 = "";
  String section2 = "";
  String section3 = "";

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {

    Provider.of<ThirdYearSelectProvider>(context, listen: false)
        .getSharedPrefencesValue();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
                    Hero(
                      tag: 'logo',
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/logo.png"),
                        backgroundColor: Color.fromARGB(255, 9, 148, 14),
                      ),
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
                    Container(
                        child: Consumer<ThirdYearSelectProvider>(
                            builder: (context, value, child) => Column(
                                  children: [
                                    Text(
                                      'Core Section: ${value.section1}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Department Elective 1: ${value.section2}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Department Elective 2: ${value.section3}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ))),
                    SizedBox(height: 40),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildAContainer(context, "Class Remainder",
                              "Manage your class remainder", () {
                            showremainderconfirmation(context,widget.weeklySchedule);
                          }, Colors.black),
                          const SizedBox(width: 10),
                          buildAContainer(
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
                          buildAContainer(
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
                          buildAContainer(
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
                    const SizedBox(height: 60),
                    // Text("This is a notice",style: TextStyle(color: Colors.greenAccent),),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black,
            child: const Text(
              '© 2024 KIIT CONNECT',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the developer information dialog
}
