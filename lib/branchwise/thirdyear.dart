import 'package:flutter/material.dart';
import 'package:kiit_kaksha/Routes/routes.dart';
import 'package:kiit_kaksha/provider/thirdyearselect.dart';
import 'package:kiit_kaksha/widgets/dropdownelective.dart';
import 'package:provider/provider.dart';

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
    final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Consumer<ThirdYearSelectProvider>(builder: (context, value, child){
             return SingleChildScrollView(
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
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
                      dropdownValue1 = value.updateDropDown1(newValue!);
                       
                  },
                  textEditingController
                  ),
                  SizedBox(height: 20),
                  buildDropdownelective(context,"Elective 1", items2, dropdownValue2,
                      (String? newValue) {
                     dropdownValue2 = value.updateDropDown2(newValue!);
                  },
                  textEditingController,
                  
                  ),
                  SizedBox(height: 20),
                  buildDropdownelective(context, "Elective 2", items3, dropdownValue3,
                      (String? newValue) {
                     dropdownValue3 = value.updateDropDown3(newValue!);
                  },
                  textEditingController
                  
                  ),
                  SizedBox(height: 70),
                  ElevatedButton(
                    onPressed: (dropdownValue1 != null &&
                            dropdownValue2 != null &&
                            dropdownValue3 != null)
                        ? () async {
                            Provider.of<ThirdYearSelectProvider>(context,listen: false).savePreferences(widget.startFromViewPage);
                            Navigator.pushReplacementNamed(
                              context, RouteManager.ThirdYearinfo, arguments: {
                                'dropvalue1': dropdownValue1,
                                'dropvalue2': dropdownValue2,
                                'dropvalue3': dropdownValue3,
                                'startfromviewpage': widget.startFromViewPage
                              }
                              // MaterialPageRoute(
                              //   builder: (context) => Views(
                              //     section1: dropdownValue1!,
                              //     section2: dropdownValue2!,
                              //     section3: dropdownValue3!,
                              //     startfromviewpage: widget.startFromViewPage,
                              //   ),
                              // ),
                            );
                          }
                        : null,
                    style: ButtonStyle(
                       backgroundColor: MaterialStateProperty.all((dropdownValue1 != null &&
                            dropdownValue2 != null &&
                            dropdownValue3 != null)? Colors.green:Colors.grey),
                    ),
                    child: Text("Submit",style: TextStyle(color: (dropdownValue1 != null &&
                            dropdownValue2 != null &&
                            dropdownValue3 != null)? Colors.white:Color.fromARGB(255, 3, 14, 77))),
                  ),
                ],
                           ),
             );
            }
          ),
        ),
            ),
      )
    );
  }



}
