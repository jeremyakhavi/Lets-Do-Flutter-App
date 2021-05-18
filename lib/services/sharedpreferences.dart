import 'package:shared_preferences/shared_preferences.dart';

/* 
-- USE SHARED PREFERENCES
  - this requirement is fufilled in this file

These methods utilise SharedPreferences to store the number of times a task
has been created using the application
 */

// function to get the current count of tasks created
Future<int> getCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final counter = prefs.getInt('counter');
  if (counter == null) {
    return 0;
  }
  return counter;
}

// function to increment the count of tasks created (called when new task is made)
Future<void> incrementCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Added $counter tasks.');
  await prefs.setInt('counter', counter);
}
