import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThirdYearSelectProvider extends ChangeNotifier{

  String dropdownDown1 ="";
  String dropdownDown2="";
  String dropdown3="";


String? section1 ="";
String? section2="";
String? section3="";


  updateDropDown1(String val){
    dropdownDown1 = val;
    notifyListeners();
    return dropdownDown1;
  }

  updateDropDown2(String val){
    dropdownDown2 = val;
    notifyListeners();
    return dropdownDown2;
  }
   updateDropDown3(String val){
    dropdown3 = val;
    notifyListeners();
    return dropdown3;
  }
    Future<void> savePreferences(bool startFromViewPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('dropdownValue1', dropdownDown1 ?? '');
    prefs.setString('dropdownValue2', dropdownDown2 ?? '');
    prefs.setString('dropdownValue3', dropdown3 ?? '');
    prefs.setBool('startFromViewPage', startFromViewPage);
  }
 



 getSharedPrefencesValue()async{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      section1 =  prefs.getString("dropdownValue1");
      section2 = prefs.getString("dropdownValue2");
      section3 = prefs.getString("dropdownValue3");
    notifyListeners();
}



}