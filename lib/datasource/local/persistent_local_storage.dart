
import 'package:shared_preferences/shared_preferences.dart';

const UNREAD_COUNT_KEY = 'UNREAD_COUNT_KEY';

// This class is mainly use for background process
class PersistentLocalStorage {
  late SharedPreferences prefs;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  void saveUnreadCount(int value){
    prefs.setInt(UNREAD_COUNT_KEY, value);
  }

  Future<int?> getUnreadCount() async {
    await prefs.reload();
    return prefs.getInt(UNREAD_COUNT_KEY);
  }
}