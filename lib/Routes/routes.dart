
import 'package:flutter/material.dart';
import 'package:kiit_kaksha/thirdyear/third_year_about.dart';
import 'package:kiit_kaksha/branchwise/secondyear.dart';
import 'package:kiit_kaksha/branchwise/secondyearabout.dart';
import 'package:kiit_kaksha/branchwise/thirdyear.dart';
import 'package:kiit_kaksha/thirdyear/third_year_view.dart';
import 'package:kiit_kaksha/SplashScreen/splashscreen.dart';
import 'package:kiit_kaksha/widgets/teacherview.dart';

class RouteManager {
  static const String Home = "./";
  static const String SecondYearSelect = "./secondyear";
  static const String ThirdYearSelect = "./thirdyear";
  static const String ThirdYearinfo = "./thirdyearinfo";
  static const String Thirdyearabout = "./thirdyearabout";
  static const String SecondYearabout = "./secondyearabout";
  static const String TeacherViewpage = "./teacherview";

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Home:
        return MaterialPageRoute(builder: (context) =>  SplashScreen());
case SecondYearSelect:
  final Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
  if (arguments != null) {
    final String year = arguments['year'] ?? '';  
    final String branch = arguments['branch'] ?? '';
    final bool startFromSecondViewPage = arguments['startFromSecondViewPage'] ?? false;
    
    return MaterialPageRoute(builder: (context) =>  SecondYear(
      year: year,
      branch: branch,
      startFromsecondViewPage: startFromSecondViewPage,
    ));
  }

  throw const FormatException("Wrong Route format");

  case ThirdYearSelect: 
  final Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
   if (arguments != null) {
    final String year = arguments['year'] ?? '';  
    final String branch = arguments['branch'] ?? '';
    final bool startFromViewPage = arguments['startFromViewPage'] ?? false;
      return MaterialPageRoute(builder: (context)=> ThirdYear(    year: year,
      branch: branch,
      startFromViewPage: startFromViewPage,
      ));
   }
   throw const FormatException("Wrong Route Format");
 
case ThirdYearinfo:
final Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
if(arguments!=null){
  final String dropvalue1 = arguments['dropvalue1'];
  final String dropvalue2 = arguments['dropvalue2'];
  final String dropvalue3 = arguments['dropvalue3'];
  final bool startfromviewpage = arguments['startfromviewpage'];
  return MaterialPageRoute(builder: (context)=> Views(section1: dropvalue1, section2: dropvalue2, section3: dropvalue3,startfromviewpage: startfromviewpage,));
}
throw const FormatException("Wrong Route Format");

case Thirdyearabout:
final Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;

if(arguments!=null){
  final Map<String, List<Map<String, dynamic>>> weeklySchedule = arguments["schedule"];

return MaterialPageRoute(builder: (context)=> AboutPage(weeklySchedule: weeklySchedule,));
}
throw const FormatException("Wrong Route Format"); 

case SecondYearabout:
final Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;

if(arguments!=null){
  final Map<String, List<Map<String, dynamic>>> weeklySchedule = arguments["schedule"];

return MaterialPageRoute(builder: (context)=> Secondyearabout(weeklySchedule: weeklySchedule,));
}
throw const FormatException("Wrong Route Format");
case TeacherViewpage:
    final Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
if(arguments!=null){
  final String teachername = arguments["teachername"];

        return MaterialPageRoute(builder: (context) =>  TeacherView(teachername: teachername,));
}else{
  throw FormatException("Wrong route exception");
}



  default:
        throw const FormatException("Wrong Route format");
    }
  }
}

