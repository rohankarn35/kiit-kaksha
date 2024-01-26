import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kiit_kaksha/Notification/notificationservice.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

   bool isshownotificationthird = prefs.getBool('startFromViewPage') ?? false;
   bool isshownotificationsecond = prefs.getBool('startFromSecondViewPage') ?? false;

   if (isshownotificationsecond || isshownotificationthird) {
  showfirebasenotificaation(message.notification?.title.toString(), message.notification?.body.toString());

     
   }else{
    print("Can't be sent");
    return;
   }
  // Check if the notification was opened by tapping on it
  if (message.data['screen'] != null) {
    navigateToPage();
  }
}

Future<void> navigateToPage() async {
  // Note: Replace 'ShowHolidayPage()' with your actual destination widget.
 
}

class FirebaseAPI {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      // Request permission
      await FirebaseMessaging.instance.getToken();
      
      FirebaseMessaging.onMessage.listen(handleBackgroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // Check if the notification was opened by tapping on it
        if (message.data['screen'] != null) {
          navigateToPage();
        }
      });

      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        // Check if the initial message was opened by tapping on it
        if (initialMessage.data['screen'] != null) {
          navigateToPage();
        }
      }
  
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }
}
