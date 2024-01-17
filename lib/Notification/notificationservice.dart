
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kiit_kaksha/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

shownotification(Map<String, List<Map<String, dynamic>>> scheduleDay) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final AndroidFlutterLocalNotificationsPlugin?
        androidFlutterLocalNotificationsPlugin =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidFlutterLocalNotificationsPlugin != null) {
      final bool? hasPermission =
          await androidFlutterLocalNotificationsPlugin.requestNotificationsPermission();

      if (hasPermission == null || !hasPermission) {
        print("Notification declined");
      } else {
        final currentDayIndex = DateTime.now().weekday;
        final String dayKey = getDayKey(currentDayIndex - 1);
        print(currentDayIndex);
        print(dayKey);

        // Check if notifications have already been scheduled for the current day
        final bool notificationsScheduled = prefs.getBool('$dayKey-notifications-scheduled') ?? false;

        if (!notificationsScheduled) {
          int startHour = 0, startMinute = 0;

          if (scheduleDay[dayKey]!.isNotEmpty) {
            for (int i = 0; i < scheduleDay[dayKey]!.length; i++) {
              String myTime = scheduleDay[dayKey]![i]["time"];
              double startTime = parseTime(myTime);
              List<int> timeStart = getTime(startTime);
              startHour = timeStart[0];
              startMinute = timeStart[1];
              String subjectName = scheduleDay[dayKey]![i]["subject"];
              String roomNo = scheduleDay[dayKey]![i]["roomNo"];

              DateTime dateTime = DateTime.now();
              DateTime notificationTime = DateTime(
                dateTime.year,
                dateTime.month,
                dateTime.day,
                startHour,
                startMinute,
              );

              AndroidNotificationDetails androidNotificationDetails =
                  AndroidNotificationDetails(
                "Notifications",
                "Kaksha Notification",
                priority: Priority.max,
                importance: Importance.min,
                visibility: NotificationVisibility.public,
              );

              NotificationDetails notificationDetails =
                  NotificationDetails(android: androidNotificationDetails);

              await notificationsPlugin.zonedSchedule(
                0,
                "$subjectName class in $roomNo",
                "Class starting in 5 minutes",
                TZDateTime.from(notificationTime, local),
                notificationDetails,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.wallClockTime,
              );
            }

            // Mark notifications as scheduled for the current day
            prefs.setBool('$dayKey-notifications-scheduled', true);
          } else {
            DateTime current = DateTime.now();
            DateTime notificationTime = DateTime(
              current.year,
              current.month,
              current.day,
              9,
            );

            AndroidNotificationDetails androidNotificationDetails =
                AndroidNotificationDetails(
              "Notifications",
              "Kaksha Notification",
              priority: Priority.max,
              importance: Importance.min,
            );

            NotificationDetails notificationDetails =
                NotificationDetails(android: androidNotificationDetails);

            await notificationsPlugin.zonedSchedule(
              0,
              "No Class Today",
              "Enjoy your day",
              TZDateTime.from(notificationTime, local),
              notificationDetails,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.wallClockTime,
            );

            // Mark notifications as scheduled for the current day
            prefs.setBool('$dayKey-notifications-scheduled', true);
          }
        } else {
          print("Notifications already scheduled for today");
        }
      }
    }
  } catch (e) {
    print("Notification error ${e.toString()}");
  }
}

double parseTime(String timeString) {
  if (timeString == '4:30-6') {
    return 4.5;
  }

  final List<String> timeParts = timeString.split('-');
  final double startTime = double.parse(timeParts[0]);
  final double endTime = double.parse(timeParts[1]);

  return startTime;
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

String getDayKey(int index) {
  switch (index) {
    case 0:
      return "MON";
    case 1:
      return "TUE";
    case 2:
      return "WED";
    case 3:
      return "THU";
    case 4:
      return "FRI";
    case 5:
      return "SAT";
    default:
      throw Exception("Invalid day index");
  }
}
