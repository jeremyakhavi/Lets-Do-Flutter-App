// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService extends ChangeNotifier {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // initialise

//   Future initialize() async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings("logo");

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: androidInitializationSettings);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   // instant notifications
//   Future instantNotification() async {
//     var android = AndroidNotificationDetails("id", "channel", "description");
//     var platform = new NotificationDetails(android: android);

//     await _flutterLocalNotificationsPlugin.show(
//         0, "Demo instant notification", "Tap to do something", platform,
//         payload: "Welcome to the Let's Do");
//   }

//   // scheduled notification
//   Future scheduledNotification() async {
//     // change to whatever interval .everyDay
//     var interval = RepeatInterval.everyMinute;
//     var android = AndroidNotificationDetails("id", "channel", "description");
//     var platform = new NotificationDetails(android: android);

//     await _flutterLocalNotificationsPlugin.periodicallyShow(
//         0,
//         "Demo schedyled notification",
//         "Tap to do something",
//         interval,
//         platform,
//         payload: "Welcome to the Let's Do");
//   }

//   // cancel notification
//   Future cancelNotification() async {
//     await _flutterLocalNotificationsPlugin.cancelAll();
//   }
// }
