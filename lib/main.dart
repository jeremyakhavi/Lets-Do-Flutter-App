import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/services/auth.dart';
import 'package:to_do_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

/*
Main file, initialises the application, and starts background services (inc. notifications)
-- USE NOTIFICATIONS
  - notification listeners are implemented here, users can receive notifications via firebase cloud messaging

-- IMPLEMENT AND USE YOUR OWN SERVICE
  - this ties in with the implementation of notifications

-- WORK PROPERLY WITH THE APP LIFECYCLE
  - screen rotations are handled here, they are enable for devices of
    screen width > 500, with smaller devices lock to only portrait mode
  - the background handlers for notification make use of the app lifecycle

-- RECEIVE BROADCAST EVENTS
  - broadcast events can be received as notifications from firebase cloud messaging
*/

// functions, constants and variables enabling app to receive push notifications from firebase console
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// function to handle receiving of notifications when app in background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A new Lets Do notification has been received: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // initialise background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  // initialise foreground notifications
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // determine screen width, limit to only portrait mode is screen width < 500
  final double screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  if (screenWidth < 500) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // use StreamProvider for value of user
    return StreamProvider<CustomUser>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        // open Wrapper widget for authentication
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
      ),
    );
  }
}
