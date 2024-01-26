import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TeacherProvider extends ChangeNotifier {
  String? teachersdata;
  String? teacherdatasecond;

  Future<void> fetchDataAndSaveToSharedPreferences(
      String section1, String section2, String section3) async {
    final apiUrl =
        'Your_link_here';

    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsondata = prefs.getString("combinedData");

      if (jsondata == null) {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);

          final section1Data = jsonData["${section1}"];
          final section2Data = jsonData["${section2}"];
          final section3Data = jsonData["${section3}"];

          final Map<String, dynamic> newData = {
            "section1": section1Data,
            "section2": section2Data,
            "section3": section3Data,
          };

          prefs.setString('combinedData', json.encode(newData));
          teachersdata = json.encode(newData);
          notifyListeners();
        } else {
          teachersdata = prefs.getString("combinedData");
          notifyListeners();
        }
      } else {
        teachersdata = jsondata;
        notifyListeners();
      }
    } catch (e) {
      print('Error: $e');
      // You might want to handle the error here
    }
  }

  Future<void> fetchDataAndSaveToSharedPreferencesSecondYear(String section1)async{

    final apiUrl = "";
     try {
      final prefs = await SharedPreferences.getInstance();
      String? jsondata = prefs.getString("combinedDataSeconYear");

      if (jsondata == null) {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);

          final section1Data = jsonData["${section1}"];

          final Map<String, dynamic> newData = {
            "section1": section1Data,
          };

          prefs.setString('combinedDataSecondYear', json.encode(newData));
          teacherdatasecond = json.encode(newData);
          notifyListeners();
        } else {
          teacherdatasecond = prefs.getString("combinedDataSecondYear");
          notifyListeners();
        }
      } else {
        teachersdata = jsondata;
        notifyListeners();
      }
    } catch (e) {
      print('Error: $e');
      // You might want to handle the error here
    }

  }
}

