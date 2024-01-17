import 'package:flutter/material.dart';

class SelectProvider extends ChangeNotifier {
  String selectSecondYear = "";
  String selectThirdYear = "";
  String selectCSE = "";
  String selectIT = "";
  String selectCSSE = "";
  String selectCSCE = "";

  String updatesecondyear() {
    selectSecondYear = "2nd Year";
    notifyListeners();
    return selectSecondYear;
  }

  String updatethirdyear() {
    selectThirdYear = "3rd Year";
    notifyListeners();
    return selectThirdYear;
  }

  String updateCSE() {
    selectCSE = "CSE";
    notifyListeners();
    return selectCSE;
  }

  String updateIT() {
    selectIT = "IT";
    notifyListeners();
    return selectIT;
  }

  String updateCSSE() {
    selectCSSE = "CSSE";
    notifyListeners();
    return selectCSSE;
  }

  String updateCSCE() {
    selectCSCE = "CSCE";
    notifyListeners();
    return selectCSCE;
  }
}
