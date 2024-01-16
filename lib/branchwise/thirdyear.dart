import 'package:flutter/material.dart';
import 'package:kiit_kaksha/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/dropmenu.dart';

class ThirdYear extends StatefulWidget {
  final String year;
  final String branch;
  final bool startFromViewPage;

  const ThirdYear({
    Key? key,
    required this.year,
    required this.branch,
    this.startFromViewPage = false,
  }) : super(key: key);

  @override
  State<ThirdYear> createState() => _ThirdYearState();
}

class _ThirdYearState extends State<ThirdYear> {
  List<String> items1 = [];
  List<String> items2 = [];
  List<String> items3 = [];
  String? dropdownValue1;
  String? dropdownValue2;
  String? dropdownValue3;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    updateDropdownItems();
  }

  void updateDropdownItems() {
    if (widget.branch == "CSE") {
      items1 = List.generate(39, (index) => "CSE-${index + 1}");
      items2 = List.generate(27, (index) => 'ML_CS-${index + 1}');
      items2.addAll(List.generate(13, (index) => 'IOT_CS-${index + 1}'));
      items3 = List.generate(6, (index) => 'NLP_CS-${index + 1}');
      items3.addAll(List.generate(34, (index) => 'DA_CS-${index + 1}'));
    } else if (widget.branch == "IT") {
      items1 = List.generate(4, (index) => "IT-${index + 1}");
      items2 = ["ML_IT-1", "ML_IT-2", "ML_IT-3", "ML_IT-4"];
      items3 = ["MC_IT-1", "MC_IT-2", "MC-IT-3", "OT_IT-1"];
    } else if (widget.branch == "CSCE") {
      items1 = ["CSCE-1", "CSCE-2"];
      items2 = ["ML_CE-1", "IOT_CE-1"];
      items3 = ["WSN_CE-1", "SCS_CE-1"];
    } else if (widget.branch == "CSSE") {
      items1 = ["CSSE-1", "CSSE-2"];
      items2 = ["DA_SE-1","DA_SE-2"];
      items3 = ["DMDW_SE-1","DMDW_SE-2"];
    }

    dropdownValue1 = null;
    dropdownValue2 = null;
    dropdownValue3 = null;
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('dropdownValue1', dropdownValue1 ?? '');
    prefs.setString('dropdownValue2', dropdownValue2 ?? '');
    prefs.setString('dropdownValue3', dropdownValue3 ?? '');
    prefs.setBool('startFromViewPage', widget.startFromViewPage);
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Text(
                "Select Core and Elective Section",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
              SizedBox(
                height: 30,
              ),
              buildDropdown(context,"Core Section", items1, dropdownValue1,
                  (String? newValue) {
                setState(() {
                  dropdownValue1 = newValue;
                });
              }),
              SizedBox(height: 16.0),
              buildDropdown(context,"Elective 1", items2, dropdownValue2,
                  (String? newValue) {
                setState(() {
                  dropdownValue2 = newValue;
                });
              }),
              SizedBox(height: 16.0),
              buildDropdown(context, "Elective 2", items3, dropdownValue3,
                  (String? newValue) {
                setState(() {
                  dropdownValue3 = newValue;
                });
              }),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: (dropdownValue1 != null &&
                        dropdownValue2 != null &&
                        dropdownValue3 != null)
                    ? () async {
                        await _savePreferences();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Views(
                              section1: dropdownValue1!,
                              section2: dropdownValue2!,
                              section3: dropdownValue3!,
                              startfromviewpage: widget.startFromViewPage,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  primary: (dropdownValue1 != null &&
                          dropdownValue2 != null &&
                          dropdownValue3 != null)
                      ? Colors.green
                      : Colors.redAccent, // Set the button color based on conditions
                ),
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
