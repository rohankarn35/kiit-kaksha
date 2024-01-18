import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiit_kaksha/Notification/notificationservice.dart';
import 'package:kiit_kaksha/about.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Views extends StatefulWidget {
  final String section1;
  final String section2;
  final String section3;
  final bool startfromviewpage;

  const Views({
    Key? key,
    required this.section1,
    required this.section2,
    required this.section3,
    this.startfromviewpage = false,
  }) : super(key: key);

  @override
  State<Views> createState() => _ViewsState();
}

class _ViewsState extends State<Views> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<Map<String, dynamic>>> weeklySchedule = {};

  @override
  void initState() {
  
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _schedulenotificationforweek();

    // Load data from SharedPreferences
    loadWeeklySchedule();
    fetchWeeklySchedule();

    // Get the current day and set the initial tab index
    final currentDayIndex = DateTime.now().weekday;
    int initialTabIndex;

    if (currentDayIndex == DateTime.sunday) {
      initialTabIndex = 0; // Monday
    } else {
      initialTabIndex = currentDayIndex - 1; // Adjust for zero-based indexing
    }

    _tabController.index = initialTabIndex;

    // Check if data for the initial tab is available, if not, fetch it
    final initialDayKey = _getDayKey(initialTabIndex);
    if (!weeklySchedule.containsKey(initialDayKey) ||
        weeklySchedule[initialDayKey]!.isEmpty) {
      fetchDataForDay(initialDayKey);
    }
  }

 



  void _handleTabSelection() {
    // print("object");
    if (_tabController.indexIsChanging) {
      final selectedDay = _tabController.index;
      final dayKey = _getDayKey(selectedDay);
      if (weeklySchedule.containsKey(dayKey) &&
          weeklySchedule[dayKey]!.isEmpty) {
        fetchDataForDay(dayKey);
      }
    }
  }

  Future<void> loadWeeklySchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 6; i++) {
      final dayKey = _getDayKey(i);
      if (prefs.containsKey(dayKey)) {
        final storedData = prefs.getString(dayKey);
        if (storedData != null) {
          final Map<String, dynamic> data = jsonDecode(storedData);
          setState(() {
            weeklySchedule[dayKey] =
                List<Map<String, dynamic>>.from(data[dayKey]);
          });
        }
      }
    }
  }

  Future<void> fetchWeeklySchedule() async {
    for (int i = 0; i < 6; i++) {
      final dayKey = _getDayKey(i);
      if (!weeklySchedule.containsKey(dayKey)) {
        await fetchDataForDay(dayKey);
      }
    }
  }

Future<void> fetchDataForDay(String dayKey) async {
  final apiUrl =
      '${dotenv.env['URL_THIRD']}${widget.section1}&section2=${widget.section2}&section3=${widget.section3}';

  // Use SharedPreferences to check if data is available offline
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(dayKey)) {
    final storedData = prefs.getString(dayKey);
    if (storedData != null) {
      final Map<String, dynamic> data = jsonDecode(storedData);
      setState(() {
        weeklySchedule[dayKey] =
            List<Map<String, dynamic>>.from(data[dayKey]);
      });
      return;
    }
  }

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey(dayKey)) {
        setState(() {
          weeklySchedule[dayKey] =
              List<Map<String, dynamic>>.from(data[dayKey]);
        });

        // Save data to SharedPreferences for offline use
        prefs.setString(dayKey, response.body);
      }
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
            'An error occurred. Click on i button and reset the app'),
        duration: Duration(seconds: 5),
      ),
    );
  }
}

Future<void> _schedulenotificationforweek() async {
  try {
    if (weeklySchedule.isEmpty) {
      await fetchWeeklySchedule();
    }

    shownotification(weeklySchedule);
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
            'An error occurred while scheduling notifications'),
        duration: Duration(seconds: 5),
      ),
    );
  }
}






  String _getDayKey(int index) {
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

  List<double> _parseTime(String timeString) {
    if (timeString == '4:30-6') {
      return [4.5, 6];
    }

    final List<String> timeParts = timeString.split('-');
    final double startTime = double.parse(timeParts[0]);
    final double endTime = double.parse(timeParts[1]);

    return [startTime, endTime];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Return true to allow back navigation, return false to prevent it
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.black38,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                ), // Change the icon as needed
                onPressed: () {
                  // Add functionality here when the icon is pressed
                  // For example, you can open a settings page or show a dialog.
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.black38,
            shadowColor: Colors.black,
            // Set the app bar color
            bottom: TabBar(
              // dragStartBehavior: DragStartBehavior.down,
              dividerColor: Colors.black,
              controller: _tabController,
              tabs: [
                const Tab(text: 'MON'),
                const Tab(text: 'TUE'),
                const Tab(text: 'WED'),
                const Tab(text: 'THU'),
                const Tab(text: 'FRI'),
                const Tab(text: 'SAT'),
              ],
              indicatorColor: Colors.white,
              labelColor: Colors.white,
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDaySchedule("MON"),
                _buildDaySchedule("TUE"),
                _buildDaySchedule("WED"),
                _buildDaySchedule("THU"),
                _buildDaySchedule("FRI"),
                _buildDaySchedule("SAT"),
              ],
            ),
          ),
        ));
  }

  Widget _buildDaySchedule(String dayKey) {
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
          final List<double> timeRange = _parseTime(scheduleItem['time']);
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
          final isCurrentDay = dayKey == _getDayKey(currentTime.weekday - 1);
          final String displayTime = scheduleItem['time'];

          final isCurrentTimeInRange =
              (currentTime.hour > startHour && currentTime.hour < endHour) ||
                  (currentTime.hour >= startHour &&
                          currentTime.minute >= startMinute) &&
                      currentTime.hour < endHour;

          final isrunningclass = isCurrentDay && isCurrentTimeInRange;

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
            child: ListTile(
              tileColor: Colors.black,
              title: Text(
                scheduleItem['subject'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: isrunningclass ? 30 : 24,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    displayTime,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: isrunningclass ? 30 : 24,
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
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
