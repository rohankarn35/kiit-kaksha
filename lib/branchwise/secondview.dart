import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiit_kaksha/about.dart';
import 'package:kiit_kaksha/branchwise/secondyearabout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondYearViews extends StatefulWidget {
  final String section1;
  final bool startfromviewpage;

  const SecondYearViews({
    Key? key,
    required this.section1,
    this.startfromviewpage = false,
  }) : super(key: key);

 @override
  State<SecondYearViews> createState() => _SecondYearViewsState();
}

class _SecondYearViewsState extends State<SecondYearViews> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<Map<String, dynamic>>> weeklySchedule = {};
  // late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // _initializeSharedPreferences();

    loadWeeklySchedule();
    fetchWeeklySchedule();

    final currentDayIndex = DateTime.now().weekday;
    int initialTabIndex;

    if (currentDayIndex == DateTime.sunday) {
      initialTabIndex = 0; // Monday
    } else {
      initialTabIndex = currentDayIndex - 1; // Adjust for zero-based indexing
    }

    _tabController.index = initialTabIndex;

    final initialDayKey = _getDayKey(initialTabIndex);
    if (!weeklySchedule.containsKey(initialDayKey) ||
        weeklySchedule[initialDayKey]!.isEmpty) {
      fetchDataForDay(initialDayKey);
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      final selectedDay = _tabController.index;
      final dayKey = _getDayKey(selectedDay);
      if (weeklySchedule.containsKey(dayKey) &&
          weeklySchedule[dayKey]!.isEmpty) {
        fetchDataForDay(dayKey);
      }
    }
  }
  void _initializeSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final apiUrl = "${dotenv.env['URL_SECOND']}${widget.section1}";
        

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

          prefs.setString(dayKey, response.body);

          for (var classInfo in weeklySchedule[dayKey]!) {
            // _scheduleNotificationForClass(classInfo);
          }
        }
      } else {
        throw Exception('Failed to load schedule');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              'An error occurred'),
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



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>  Secondyearabout()));
              },
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.black38,
          shadowColor: Colors.black,
          bottom: TabBar(
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
      ),
    );
  }
Widget _buildDaySchedule(String dayKey) {
  if (weeklySchedule.containsKey(dayKey) && weeklySchedule[dayKey] != null) {
    final schedule = weeklySchedule[dayKey]!;
    if (schedule.isEmpty) {
      return const Center(
        child: Text("No classes today", style: TextStyle(fontSize: 30, color: Colors.white)),
      );
    }

    // Get the current time
    final currentTime = DateTime.now();

    return ListView.builder(
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final scheduleItem = schedule[index];

        // Convert time from 1-6 to 13-18
        int startTime = int.parse(scheduleItem['time'].split('-')[0]);
        int endTime = int.parse(scheduleItem['time'].split('-')[1]);

        // Adjust the conversion for the hour 12
        if (startTime >= 1 && startTime <= 6) {
          startTime = startTime + 12;
        }

        if (endTime >= 1 && endTime <= 6) {
          endTime = endTime + 12;
        }

        // Display time in 1-2 format
        final displayTime = '${scheduleItem['time']}';

        // Check if the current time is within the specified range and if it's the correct day
        final isCurrentDay = dayKey == _getDayKey(currentTime.weekday - 1);
        final isCurrentTimeInRange = currentTime.hour >= startTime && currentTime.hour < endTime;

        final isrunningclass = isCurrentDay && isCurrentTimeInRange;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: isrunningclass ? 10 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isrunningclass?Colors.green: Colors.white54,
              width: isrunningclass?3:1,
              
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