import 'package:flutter/material.dart';
import 'package:kiit_kaksha/Notification/notificationservice.dart';
import 'package:kiit_kaksha/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showremainderconfirmation(BuildContext context,
    Map<String, List<Map<String, dynamic>>> weeklySchedule) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isTurnedOn = prefs.getBool("remainderval") ?? true; // Default value is true

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text("Select your preference"),
        actions: [
          TextButton(
            onPressed: () async {
              if (isTurnedOn) {
                prefs.setBool("remainderval", false);
                notificationsPlugin.cancelAll();
              } else {
                prefs.setBool("remainderval", true);
                shownotification(weeklySchedule, context);
              }
              Navigator.pop(context);
            },
            child: Text(isTurnedOn ? 'Turn off' : 'Turn on'),
          ),
        ],
      );
    },
  );
}
