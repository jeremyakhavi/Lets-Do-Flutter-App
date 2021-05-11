import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  Future<int> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startupNumber = prefs.getInt('startupNumber');
    if (startupNumber == null) {
      return 0;
    }
    return startupNumber;
  }

  static Future<void> incrementCount() async {
    final prefs = await SharedPreferences.getInstance();
  }
}
