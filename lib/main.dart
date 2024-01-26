import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kiit_kaksha/Routes/routes.dart';
import 'package:kiit_kaksha/firebase_options.dart';
import 'package:kiit_kaksha/firebaseapi/firebaseapi.dart';
import 'package:kiit_kaksha/provider/selectprovider.dart';
import 'package:kiit_kaksha/provider/teacherprovider.dart';
import 'package:kiit_kaksha/provider/thirdyearselect.dart';
import 'package:kiit_kaksha/SplashScreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  try {
    await dotenv.load();
    initializeTimeZones();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAPI().initNotifications();

    WidgetsFlutterBinding.ensureInitialized();
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/launcher_icon");
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    bool? initialized =
        await notificationsPlugin.initialize(initializationSettings);
    // print("Notification setting $initialized");
    runApp(MyApp());
  } catch (error) {
    print('Error loading .env file: ${error.toString()}');
  }
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    analytics.logEvent(name: 'myapp', parameters: {'myappscren': 'home'});

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SelectProvider()),
          ChangeNotifierProvider(
              create: (context) => ThirdYearSelectProvider()),
              ChangeNotifierProvider(create: (context)=> TeacherProvider())
             
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: RouteManager.Home,
          onGenerateRoute: RouteManager.generateRoutes,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        ));
  }
}
