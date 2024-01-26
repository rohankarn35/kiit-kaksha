import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ThirdYearSelectProvider extends ChangeNotifier {
  String dropdownDown1 = "";
  String dropdownDown2 = "";
  String dropdown3 = "";
  String dropdown4 = "";

  String? section1 = "";
  String? section2 = "";
  String? section3 = "";
  String? section4 = "";
    String title = "";
  String desc = "";
  bool isborder = false;

  updateDropDown1(String val) {
    dropdownDown1 = val;
    notifyListeners();
    return dropdownDown1;
  }

  updateDropDown2(String val) {
    dropdownDown2 = val;
    notifyListeners();
    return dropdownDown2;
  }

  updateDropDown3(String val) {
    dropdown3 = val;
    notifyListeners();
    return dropdown3;
  }
  updateDropDown4(String val) {
    dropdown4 = val;
    notifyListeners();
    return dropdown4;
  }


  Future<void> savePreferences(bool startFromViewPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('dropdownValue1', dropdownDown1);
    prefs.setString('dropdownValue2', dropdownDown2);
    prefs.setString('dropdownValue3', dropdown3);
    prefs.setString("dropdownValue4", dropdown4);
    prefs.setBool('startFromViewPage', startFromViewPage);
  }

  getSharedPrefencesValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    section1 = prefs.getString("dropdownValue1");
    section2 = prefs.getString("dropdownValue2");
    section3 = prefs.getString("dropdownValue3");
    section4 = prefs.getString("dropdownValue4");
    notifyListeners();
  }

    Future<void> apiserviceabout(BuildContext context) async {
    final url = "your_link_here";

  

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      title = data["NOTICE"]["notice"];
      desc = data["NOTICE"]["desc"];
      if (desc.isNotEmpty) {
        isborder = true;
        
      }
      notifyListeners();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "An error occurred. Please check your internet connection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

}
