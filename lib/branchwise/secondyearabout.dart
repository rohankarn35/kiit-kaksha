import 'package:flutter/material.dart';
import 'package:kiit_kaksha/aboutwidgets/showconfirmation.dart';
import 'package:kiit_kaksha/aboutwidgets/showremainder.dart';
import 'package:kiit_kaksha/aboutwidgets/showreport.dart';


import 'package:shared_preferences/shared_preferences.dart';
import '../dialogbox/showdeveloper.dart';
import '../widgets/aboutwidget.dart';


class Secondyearabout extends StatefulWidget {

  final Map<String, List<Map<String, dynamic>>> weeklySchedule;


  const Secondyearabout({Key? key, required this.weeklySchedule}) : super(key: key);

  @override
  State<Secondyearabout> createState() => _SecondyearaboutState();
}

class _SecondyearaboutState extends State<Secondyearabout> {
  late String section1 = "";

  void getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      section1 = prefs.getString("dropdownValue4") ?? " ";

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
                    const SizedBox(height: 40),
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
              '© 2024 KIIT CONNECT',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }




}