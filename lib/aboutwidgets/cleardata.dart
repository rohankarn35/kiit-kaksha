

import 'package:flutter/material.dart';
import 'package:kiit_kaksha/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> clearLocalData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notificationsPlugin.cancelAll().then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      backgroundColor: Colors.green,
      content: Center(child: Text("Data Cleared")))));
  }
