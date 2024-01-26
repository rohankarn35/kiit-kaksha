import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:kiit_kaksha/Routes/routes.dart';
import 'package:kiit_kaksha/widgets/builddaily.dart';

Widget buildDaythirdSchedule(String dayKey, Map<String, List<Map<String, dynamic>>> weeklySchedule,String? jsondata) {
// jsondata = jsonEncode(jsondata);
final json = jsonDecode(jsondata!);
  
  // print(json);
  if (weeklySchedule.containsKey(dayKey) && weeklySchedule[dayKey] != null) {
    final schedule = weeklySchedule[dayKey]!;
    if (schedule.isEmpty) {
      return const Center(
        child: Text("No classes today",
            style: TextStyle(fontSize: 30, color: Colors.white)),
      );
    }

    // Get the current time
    final currentTime = DateTime.now();

    return ListView.builder(
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final scheduleItem = schedule[index];

        // Convert time from 1-6 to 13-18
        final List<double> timeRange = parseTime(scheduleItem['time']);
        double startTime = timeRange[0];
        double endTime = timeRange[1];

        // Convert start time and end time to hours and minutes
        int startHour = startTime.floor();
        int startMinute = ((startTime - startHour) * 60).round();
        int endHour = endTime.floor();
        int endMinute = ((endTime - endHour) * 60).round();

        if (startHour >= 1 && startHour <= 6) {
          startHour = startHour + 12;
        }

        if (endHour >= 1 && endHour <= 6) {
          endHour = endHour + 12;
        }

        // Check if the current time is within the specified range and if it's the correct day
        final isCurrentDay = dayKey == getDayKey(currentTime.weekday - 1);
        final String displayTime = scheduleItem['time'];

        final isCurrentTimeInRange =
        (currentTime.hour > startHour && currentTime.hour < endHour) ||
            (currentTime.hour >= startHour &&
                currentTime.minute >= startMinute) &&
                currentTime.hour < endHour;

        final isrunningclass = isCurrentDay && isCurrentTimeInRange;
        final String subjects = scheduleItem['subject'];

     
         final String section1Value = json.containsKey("section1") ? json["section1"][subjects] ?? '' : '';
        final String section2Value = json.containsKey("section2") ? json["section2"][subjects] ?? '' : '';
        final String section3Value = json.containsKey("section3") ? json["section3"][subjects] ?? '' : '';
         String sectionvalue = "$section1Value$section2Value$section3Value ";
 

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: isrunningclass ? 10 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isrunningclass ? Colors.green : Colors.white54,
              width: isrunningclass ? 3 : 1,
            ),
          ),
          shadowColor: isrunningclass ? Colors.green : Colors.white,
          child: GestureDetector(
            onTap: ()async{
            //  await apiservice(context);
              Navigator.pushNamed(context, RouteManager.TeacherViewpage,arguments: {
                "teachername":sectionvalue
              });
              
            },
            child: ListTile(
              tileColor: Colors.black,
              title: Row(
                  children:[ Text(
                    scheduleItem['subject'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: isrunningclass ? 30 : 24,
                    ),
                  ),
                    SizedBox(width: 5,),
            
                  Text("|",style: TextStyle(fontSize: isrunningclass?30:24,color: Colors.white),),
                    SizedBox(width: 10,),
                    Expanded(child: Text("$sectionvalue", style: TextStyle(color: Colors.grey,fontSize: 15),)),
                    ]
              ),
              subtitle: Row(
                children: [
                  Text(
                    displayTime,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: isrunningclass ? 30: 24,
                    ),
                  ),
                  Text(
                    ' |',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isrunningclass ? 26 : 20,
                    ),
                  ),
                  Text(
                    ' ${scheduleItem['roomNo']}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isrunningclass ? 26 : 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  } else {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          JumpingDots(
            color: Colors.white,
          ),
          SizedBox(height: 20,),
          Text("Fetching data...",style:TextStyle(color: Colors.grey),)
        ],
      ),
    );
  }
}
