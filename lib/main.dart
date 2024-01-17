import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kiit_kaksha/Routes/routes.dart';
import 'package:kiit_kaksha/provider/listprovider.dart';
import 'package:kiit_kaksha/provider/selectprovider.dart';
import 'package:kiit_kaksha/provider/thirdyearselect.dart';
import 'package:kiit_kaksha/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_10y.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  try {
    await dotenv.load();
    initializeTimeZones();
    WidgetsFlutterBinding.ensureInitialized();
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    bool? initialized =
        await notificationsPlugin.initialize(initializationSettings);
    print("Notification setting $initialized");
    runApp(MyApp());
  } catch (error) {
    print('Error loading .env file: ${error.toString()}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SelectProvider()),
          ChangeNotifierProvider(
              create: (context) => ThirdYearSelectProvider()),
              ChangeNotifierProvider(create: (context)=> ListProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: RouteManager.Home,
          onGenerateRoute: RouteManager.generateRoutes,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: SplashScreen(),
        ));
  }
}
