import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kiit_kaksha/splashscreen.dart';

void main() async {
  try {
    await dotenv.load();
    WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
