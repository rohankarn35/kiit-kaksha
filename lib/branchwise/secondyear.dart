import 'package:flutter/material.dart';
import 'package:kiit_kaksha/branchwise/secondview.dart';
// import 'package:kiit_kaksha/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/dropmenu.dart';

class SecondYear extends StatefulWidget {
  final String year;
  final String branch;
  final bool startFromsecondViewPage;

  const SecondYear({
    Key? key,
    required this.year,
    required this.branch,
      this.startFromsecondViewPage = false,
  }) : super(key: key);

  @override
  State<SecondYear> createState() => _SecondYearState();
}

class _SecondYearState extends State<SecondYear> {
  List<String> items1 = [];
  String? dropdownValue1;
   final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    updateDropdownItems();
  }

  void updateDropdownItems() {
    if (widget.branch == "CSE") {
      items1 = List.generate(55, (index) => "CSE-${index + 1}");
    } else if (widget.branch == "IT") {
      items1 = List.generate(5, (index) => "IT-${index + 1}");
    } else if (widget.branch == "CSCE") {
      items1 = ["CSCE-1", "CSCE-2","CSCE-3"];
    } else if (widget.branch == "CSSE") {
      items1 = ["CSSE-1", "CSSE-2"];
    }

    dropdownValue1 = null;
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('dropdownValue4', dropdownValue1 ?? '');
    prefs.setBool('startFromSecondViewPage', widget.startFromsecondViewPage);
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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  SizedBox(height: 50,),

              Center(
                  child: Text(
                "Select Core Section",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
              SizedBox(
                height: 30,
              ),
              buildDropdown(context, "Core Section", items1, dropdownValue1,
                  (String? newValue) {
                setState(() {
                  dropdownValue1 = newValue;
                });
              },
              textEditingController
              
              ),
              SizedBox(height: 70),
              ElevatedButton(
                onPressed: (dropdownValue1 != null)
                    ? () async {
                        await _savePreferences();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondYearViews(
                              section1: dropdownValue1!,
                              startfromviewpage: widget.startFromsecondViewPage,
                            ),
                            
                          ),
                        
                        );
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all((dropdownValue1 != null)
                      ? Colors.green
                      : Colors.grey, )
                ),
                child: Text("Submit", style: TextStyle(color: (dropdownValue1 != null)
                      ? Colors.white
                      : Color.fromARGB(255, 3, 14, 77),),),
              ),
            ],
          ),
        ),
      ),
    );
  }


}


