import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiit_kaksha/Notification/notificationservice.dart';
import 'package:kiit_kaksha/Routes/routes.dart';
import 'package:kiit_kaksha/provider/teacherprovider.dart';
import 'package:kiit_kaksha/widgets/builddaily.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondYearViews extends StatefulWidget {
  final String section1;
  final bool startfromviewpage;

  const SecondYearViews({
    Key? key,
    required this.section1,
    this.startfromviewpage = true,
  }) : super(key: key);

  @override
  State<SecondYearViews> createState() => _SecondYearViewsState();
}

class _SecondYearViewsState extends State<SecondYearViews>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<Map<String, dynamic>>> weeklySchedule = {};
  // late SharedPreferences prefs;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late Future<void> teachersdata;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(_handleTabSelection);
    analytics.setAnalyticsCollectionEnabled(true);

    // _initializeSharedPreferences();
    _schedulenotificationforweek();

    loadWeeklySchedule();
    fetchWeeklySchedule();
    teachersdata = Provider.of<TeacherProvider>(context, listen: false)
        .fetchDataAndSaveToSharedPreferencesSecondYear(widget.section1);

    final currentDayIndex = DateTime.now().weekday;
    int initialTabIndex;

    initialTabIndex = currentDayIndex - 1; // Adjust for zero-based indexing

    _tabController.index = initialTabIndex;

    final initialDayKey = getDayKey(initialTabIndex);
    if (!weeklySchedule.containsKey(initialDayKey) ||
        weeklySchedule[initialDayKey]!.isEmpty) {
      fetchDataForDay(initialDayKey);
    }
  }

  Future<void> _schedulenotificationforweek() async {
    if (weeklySchedule.isEmpty) {
      await fetchWeeklySchedule();
    }

    shownotification(weeklySchedule, context);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      final selectedDay = _tabController.index;
      final dayKey = getDayKey(selectedDay);
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
    for (int i = 0; i < 7; i++) {
      final dayKey = getDayKey(i);
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
    for (int i = 0; i < 7; i++) {
      final dayKey = getDayKey(i);
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
        print("Store ${storedData}");
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
        }
      } else if (response.statusCode == 429) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Too many request. Please try again later'),
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        throw Exception('Failed to load schedule');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              'An error occured, please check your internet connection or clear the app data'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    analytics.logEvent(
        name: 'view_second_year',
        parameters: {'view_second_year': 'view_second_year'});

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );

        if (exit ?? false) {
          // Exit the whole app
          SystemNavigator.pop();
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Text(
                    'KIIT ',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'KAKSHA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              iconSize: 25,
              icon: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ), // Change the icon as needed
              onPressed: () {
                Navigator.pushNamed(context, RouteManager.SecondYearabout,
                    arguments: {
                      "schedule": weeklySchedule,
                    });
              },
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.black38,
          shadowColor: Colors.black,
          // Set the app bar color
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: DefaultTabController(
            length: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // SizedBox(height: 10,),
                TabBar(
                  // physics: BouncingScrollPhysics(),
                  // indicatorPadding: EdgeInsets.zero,
                  dividerColor: Colors.black,
                  labelStyle:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  isScrollable: true,
                  controller: _tabController,
                  tabs: [
                    const Tab(text: 'Monday'),
                    const Tab(text: 'Tuesday'),
                    const Tab(text: 'Wednesday'),
                    const Tab(text: 'Thursday'),
                    const Tab(text: 'Friday'),
                    const Tab(text: 'Saturday'),
                    const Tab(text: 'Sunday'),
                  ],
                  indicatorColor: Colors.white,
                  tabAlignment: TabAlignment.center,
                  labelColor: Colors.white,
                  unselectedLabelStyle: TextStyle(fontSize: 20),
                  //  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: teachersdata,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      return Expanded(
                          child: Consumer<TeacherProvider>(
                        builder: (context, value, child) => TabBarView(
                          controller: _tabController,
                          children: [
                            buildDaySchedule("MON", weeklySchedule,
                                value.teacherdatasecond!),
                            buildDaySchedule("TUE", weeklySchedule,
                                value.teacherdatasecond!),
                            buildDaySchedule("WED", weeklySchedule,
                                value.teacherdatasecond!),
                            buildDaySchedule("THU", weeklySchedule,
                                value.teacherdatasecond!),
                            buildDaySchedule("FRI", weeklySchedule,
                                value.teacherdatasecond!),
                            buildDaySchedule("SAT", weeklySchedule,
                                value.teacherdatasecond!),
                            buildDaySchedule("SUN", weeklySchedule,
                                value.teacherdatasecond!),
                          ],
                        ),
                      ));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
