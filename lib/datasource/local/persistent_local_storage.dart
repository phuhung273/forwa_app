
import 'package:shared_preferences/shared_preferences.dart';

const UNREAD_COUNT_KEY = 'UNREAD_COUNT_KEY';
const BACKGROUND_PROCESSING_ORDER_LIST_KEY = 'BACKGROUND_PROCESSING_ORDER_LIST_KEY';
const BACKGROUND_SELECTED_ORDER_LIST_KEY = 'BACKGROUND_SELECTED_ORDER_LIST_KEY';
const BACKGROUND_UPLOAD_LIST_KEY = 'BACKGROUND_UPLOAD_LIST_KEY';
const BACKGROUND_SELECTED_ROOM_LIST_KEY = 'BACKGROUND_SELECTED_ROOM_LIST_KEY';

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

  Future<List<String>?> getBackgroundProcessingOrderList() async {
    await prefs.reload();
    return prefs.getStringList(BACKGROUND_PROCESSING_ORDER_LIST_KEY);
  }

  void eraseBackgroundProcessingOrderList(){
    prefs.setStringList(BACKGROUND_PROCESSING_ORDER_LIST_KEY, []);
  }

  Future<List<String>?> getBackgroundSelectedOrderList() async {
    await prefs.reload();
    return prefs.getStringList(BACKGROUND_SELECTED_ORDER_LIST_KEY);
  }

  void eraseBackgroundSelectedOrderList(){
    prefs.setStringList(BACKGROUND_SELECTED_ORDER_LIST_KEY, []);
  }

  Future<List<String>?> getBackgroundUploadList() async {
    await prefs.reload();
    return prefs.getStringList(BACKGROUND_UPLOAD_LIST_KEY);
  }

  void eraseBackgroundUploadList(){
    prefs.setStringList(BACKGROUND_UPLOAD_LIST_KEY, []);
  }

  Future<List<String>?> getBackgroundSelectedRoomList() async {
    await prefs.reload();
    return prefs.getStringList(BACKGROUND_SELECTED_ROOM_LIST_KEY);
  }

  void eraseBackgroundSelectedRoomList(){
    prefs.setStringList(BACKGROUND_SELECTED_ROOM_LIST_KEY, []);
  }
}