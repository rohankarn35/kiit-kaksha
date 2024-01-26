import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kiit_kaksha/aboutwidgets/showconfirmation.dart';
import 'package:kiit_kaksha/aboutwidgets/showremainder.dart';
import 'package:kiit_kaksha/aboutwidgets/showreport.dart';
import 'package:kiit_kaksha/provider/thirdyearselect.dart';
import 'package:kiit_kaksha/widgets/aboutwidget.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../dialogbox/showdeveloper.dart';

class AboutPage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> weeklySchedule;
  AboutPage({Key? key, required this.weeklySchedule}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    // apiserviceabout();
    analytics.setAnalyticsCollectionEnabled(true);

    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {

    Provider.of<ThirdYearSelectProvider>(context, listen: false)
        .getSharedPrefencesValue();
    Provider.of<ThirdYearSelectProvider>(context, listen: false)
        .apiserviceabout(context);
    // });
    analytics.setAnalyticsCollectionEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    analytics.logEvent(name: 'about_3rd_year', parameters: {'screen': 'home'});

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          // title: Text('About Us'),
        ),
        body: Consumer<ThirdYearSelectProvider>(
          builder: (context, value, child) => Column(
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
                            child: Column(
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
                        )),
                        SizedBox(height: 40),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                'About Developer',
                                'Get to know about the developer',
                                () {
                                  analytics.logEvent(
                                      name: 'aboutdeveloperthree',
                                      parameters: {
                                        'aboutdeveloperthree':
                                            'aboutdeveloperthree'
                                      });

                                  // Handle the action to show developer information
                                  showDeveloperDialog(context);
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
                        !value.isborder
                            ? Container() // Instead of Text(""), use an empty Container
                            : Center(
                                child: Container(
                                  height: 175,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0,
                                        bottom: 15,
                                        left: 20,
                                        right: 20),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 16),
                                          Text(
                                            value.title,
                                            style: TextStyle(
                                              color: Colors
                                                  .green, // Adjusted color
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              // Adjusted font size
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            value.desc,
                                            style: TextStyle(
                                              color: Colors
                                                  .white54, // Adjusted color
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
        ));
  }

  // Function to show the developer information dialog
}
