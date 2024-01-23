import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiit_kaksha/Routes/routes.dart';
import 'package:kiit_kaksha/provider/selectprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchSelect extends StatefulWidget {
  @override
  _BranchSelectState createState() => _BranchSelectState();
}

class _BranchSelectState extends State<BranchSelect> {
  String selectedYear = "";
  String selectedBranch = "";
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    analytics.setAnalyticsCollectionEnabled(true);
  }

  bool get canSubmit => selectedYear.isNotEmpty && selectedBranch.isNotEmpty;
  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('selectedyear', selectedYear ?? '');
    prefs.setString('selectedbranch', selectedBranch ?? '');
  }

  void _showSelectionErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selection Error'),
          content:
              Text('Please select your branch and year before proceeding.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
    
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Consumer<SelectProvider>(builder: (context, value, child) {
            return Container(
              child: Column(
                children: [
                  // Upper Part with Dark Green Background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: Colors.green.shade800,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.green.shade500.withOpacity(0.3),
                      //     spreadRadius: 5,
                      //     blurRadius: 7,
                      //     offset: Offset(0, 3),
                      //   ),
                      // ],
                    ),
                    height: MediaQuery.of(context).size.height / 3.5,
                    // color: Colors.green,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        Center(
                          child: Text(
                            "WELCOME TO KIIT KAKSHA",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                            child: Text(
                          "An initiative by the KIIT CONNECT Team",
                          style: TextStyle(color: Colors.white),
                        ))
                      ],
                    ),
                  ),
        
                  // Lower Part with Black Background
                  SingleChildScrollView(
                    child: Container(
                      // color: Colors.white,
                      margin: EdgeInsets.only(top: 60),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                              "Select Your Year and Branch",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              'Select Year',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
            analytics.logEvent(name: 'button_second_year', parameters: {'button_second_year': 'button_second_year'});
        
                                    selectedYear = value.updatesecondyear();
                                    print(value.updatesecondyear());
                                  },
                                  child: Text(
                                    '2nd Year',
                                    style: TextStyle(
                                        color: selectedYear == "2nd Year"
                                            ? Colors.white
                                            : Color.fromARGB(255, 3, 14, 77)),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        selectedYear == "2nd Year"
                                            ? Colors.green
                                            : Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
            analytics.logEvent(name: 'button_third_year', parameters: {'button_third_year': 'button_third_year'});
        
                                    selectedYear = value.updatethirdyear();
                                  },
                                  child: Text(
                                    '3rd Year',
                                    style: TextStyle(
                                        color: selectedYear == "3rd Year"
                                            ? Colors.white
                                            : Color.fromARGB(255, 3, 14, 77)),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        selectedYear == "3rd Year"
                                            ? Colors.green
                                            : Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Select Branch:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    selectedBranch = value.updateCSE();
                                  },
                                  child: Text(
                                    'CSE',
                                    style: TextStyle(
                                        color: selectedBranch == "CSE"
                                            ? Colors.white
                                            : Color.fromARGB(255, 3, 14, 77)),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        selectedBranch == "CSE"
                                            ? Colors.green
                                            : Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    selectedBranch = value.updateIT();
                                  },
                                  child: Text(
                                    'IT',
                                    style: TextStyle(
                                        color: selectedBranch == "IT"
                                            ? Colors.white
                                            : Color.fromARGB(255, 3, 14, 77)),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        selectedBranch == "IT"
                                            ? Colors.green
                                            : Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    selectedBranch = value.updateCSSE();
                                  },
                                  child: Text(
                                    'CSSE',
                                    style: TextStyle(
                                        color: selectedBranch == "CSSE"
                                            ? Colors.white
                                            : Color.fromARGB(255, 3, 14, 77)),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        selectedBranch == "CSSE"
                                            ? Colors.green
                                            : Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    selectedBranch = value.updateCSCE();
                                  },
                                  child: Text(
                                    'CSCE',
                                    style: TextStyle(
                                        color: selectedBranch == "CSCE"
                                            ? Colors.white
                                            : Color.fromARGB(255, 3, 14, 77)),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        selectedBranch == "CSCE"
                                            ? Colors.green
                                            : Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 70),
                          ],
                        ),
                      ),
                    ),
                  ),
        
                  ElevatedButton(
                    // onPressed: (){},
                    onPressed: canSubmit
                        ? () async {
                            _savePreferences();
        
                            // Use the selectedYear and selectedBranch for navigation or other actions
                            if (canSubmit) {
                              if (selectedYear == "2nd Year") {
                                Navigator.pushNamed(
                                    context, RouteManager.SecondYearSelect,
                                    arguments: {
                                      "year": selectedYear,
                                      "branch": selectedBranch,
                                      "startFromSecondViewPage": true,
                                    });
                              } else if (selectedYear == "3rd Year") {
                                Navigator.pushNamed(
                                    context, RouteManager.ThirdYearSelect,
                                    arguments: {
                                      "year": selectedYear,
                                      "branch": selectedBranch,
                                      "startFromViewPage": true,
                                    });
                              }
                            } else {
                              _showSelectionErrorDialog();
                            }
                          }
                        : null,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 16,
                          color: canSubmit
                              ? Colors.white
                              : Color.fromARGB(255, 3, 14, 77)),
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(120, 40)),
                      backgroundColor: MaterialStateProperty.all(
                          canSubmit ? Colors.green : Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
