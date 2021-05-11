import 'package:shared_preferences/shared_preferences.dart';

Future<int> getCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final counter = prefs.getInt('counter');
  if (counter == null) {
    return 0;
  }
  return counter;
}

Future<void> incrementCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Added $counter tasks.');
  await prefs.setInt('counter', counter);
}
