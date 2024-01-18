import 'package:flutter/material.dart';
import 'package:kiit_kaksha/Routes/routes.dart';
import 'package:kiit_kaksha/branchwise/secondyear.dart';
import 'package:kiit_kaksha/branchwise/thirdyear.dart';
import 'package:kiit_kaksha/provider/selectprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchSelect extends StatefulWidget {
  @override
  _BranchSelectState createState() => _BranchSelectState();
}

enum Year { first, second, third }

class _BranchSelectState extends State<BranchSelect> {
  String selectedYear = "";
  String selectedBranch = "";

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
          // Return true to allow back navigation, return false to prevent it
          return false;
        },
    child: Scaffold(
      
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
         iconTheme: IconThemeData(
          color: Colors.white
        ),
        // title: Text('Branch Selection'),
        backgroundColor: Colors.black, // Set the app bar color
      ),
      body: Consumer<SelectProvider>(builder: (context, value, child) {
       return Container(
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
                     selectedYear = value.updatesecondyear();
                     print(value.updatesecondyear());
                    },
                    child: Text('2nd Year'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          selectedYear == "2nd Year"
                              ? Colors.green
                              : Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                     selectedYear = value.updatethirdyear();
                   
                    },
                    child: Text('3rd Year'),
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
                    child: Text('CSE'),
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
                    child: Text('IT'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          selectedBranch == "IT" ? Colors.green : Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectedBranch = value.updateCSSE();
                    },
                    child: Text('CSSE'),
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
                    child: Text('CSCE'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          selectedBranch == "CSCE"
                              ? Colors.green
                              : Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Selected Year: $selectedYear',
                style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 201, 91, 84)),
              ),
              Text(
                'Selected Branch: $selectedBranch',
                style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 201, 91, 84)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: canSubmit
                    ? () async {
                        _savePreferences();

                        // Use the selectedYear and selectedBranch for navigation or other actions
                        if (canSubmit) {
                          if (selectedYear == "2nd Year") {
                            Navigator.pushNamed(
                              context,
                                RouteManager.SecondYearSelect,
                                          arguments: {
                                            "year": selectedYear,
                                            "branch": selectedBranch,
                                            "startFromSecondViewPage": true,
                                                
                                          });
                              // MaterialPageRoute(
                              //   builder: (context) => SecondYear(
                              //     year: selectedYear,
                              //     branch: selectedBranch,
                              //     startFromsecondViewPage: true,
                              //   ),
                              // ),
                            // );
                          } else if (selectedYear == "3rd Year") {
                            Navigator.pushNamed(
                              context, RouteManager.ThirdYearSelect,arguments: {
                                 "year": selectedYear,
                                            "branch": selectedBranch,
                                            "startFromViewPage": true,
                              }
                              
                            );
                          }
                        } else {
                          _showSelectionErrorDialog();
                        }
                      }
                    : null,
                child: Text('Submit'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      canSubmit ? Colors.green : Colors.grey),
                ),
              ),
              SizedBox(
                height: 40,
              ),
             
            ],
          ),
        ),
      );
      },)
    )
        );
  }
}
