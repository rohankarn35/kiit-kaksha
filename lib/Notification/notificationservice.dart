import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kiit_kaksha/main.dart';
import 'package:kiit_kaksha/widgets/builddaily.dart';
import 'package:permission_asker/permission_asker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

void shownotification(Map<String, List<Map<String, dynamic>>> scheduleDay,
    BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final AndroidFlutterLocalNotificationsPlugin? androidNotificationsPlugin =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidNotificationsPlugin != null) {
      final bool? hasPermission =
          await androidNotificationsPlugin.requestNotificationsPermission();

      if (hasPermission == null || !hasPermission) {
        openAppSettings();
        // Permissions not granted, handle accordingly (e.g., show a message to the user)
        print('Notification permissions not granted.');
      } else {
        // Permissions granted, proceed with scheduling notification
        bool isTurnedOn = prefs.getBool("remainderval") ?? true;
        if (isTurnedOn) {
          AndroidNotificationDetails androidDetails =
              AndroidNotificationDetails(
            "Kaksha Notification",
            "My Notification",
            priority: Priority.max,
            importance: Importance.max,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([500, 200, 500, 200, 500]),
          );
          NotificationDetails notificationDetails = NotificationDetails(
            android: androidDetails,
          );
          final currentDayIndex = DateTime.now().weekday;

          final String dayKey = getDayKey(currentDayIndex - 1);

          print(currentDayIndex);
          print(dayKey);

          int startHour = 0, startMinute = 0;

          if (scheduleDay[dayKey]!.isNotEmpty) {
            DateTime now = DateTime.now();

            for (int i = 0; i < scheduleDay[dayKey]!.length; i++) {
              String myTime = scheduleDay[dayKey]![i]["time"];
              List<double> start = parseTime(myTime);
              double startTime = start[0];
              List<int> timeStart = getTime(startTime);
              startHour = timeStart[0];
              startMinute = timeStart[1];
              String subjectName = scheduleDay[dayKey]![i]["subject"];
              String roomNo = scheduleDay[dayKey]![i]["roomNo"];

              DateTime notificationTime = DateTime(
                now.year,
                now.month,
                now.day,
                startHour,
                startMinute,
              );
// DateTime notificationTime = now.add(Duration(seconds: 2));

              if (now.isAfter(notificationTime)) {
                print(
                    "Skipped scheduling for $subjectName at $notificationTime the time has already passed");
                continue;
              }

              await notificationsPlugin
                  .zonedSchedule(
                i,
                "$subjectName class in $roomNo",
                "Class starting in 5 minutes",
                TZDateTime.from(notificationTime, local),
                notificationDetails,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.wallClockTime,
// androidScheduleMode: AndroidScheduleMode.exact
              )
                  .then((value) {
// ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Notification Scheduled for $subjectName at $notificationTime")));
                print(
                    "Notification scheuled $subjectName at $notificationTime");
              });
            }
          }
        }
      }
    }
  } catch (e) {
    print("Notification error ${e.toString()}");
  }
}

List<int> getTime(double startTime) {
  int startHour = startTime.floor();
  int startMinute = ((startTime - startHour) * 60).round();
  if (startHour >= 1 && startHour <= 6) {
    startHour = startHour + 12;
  }

  startMinute -= 5;
  if (startMinute < 0) {
    startHour -= 1;
    startMinute += 60;
  }
  if (startHour < 0) {
    startMinute += 24;
  }

  return [startHour, startMinute];
}


void showfirebasenotificaation(String? title, String? body){

  try {
      AndroidNotificationDetails androidDetails =
              AndroidNotificationDetails(
            "Holiday Notification",
            "Holiday Notice",
            priority: Priority.max,
            importance: Importance.max,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([500, 200, 500, 200, 500]),
          );
          NotificationDetails notificationDetails = NotificationDetails(
            android: androidDetails,
          );
          DateTime nowdate = DateTime.now();

          notificationsPlugin.show(nowdate.year, title, body, notificationDetails);
    
  } catch (e) {
    print(e);
    
  }

}
