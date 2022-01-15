
import 'package:get_storage/get_storage.dart';

const CHAT_SESSIONID_KEY = 'CHAT_SESSIONID_KEY';
const ACCESSTOKEN_KEY = 'ACCESSTOKEN_KEY';
const USERID_KEY = 'USERID_KEY';
const AVATAR_URL_KEY = 'AVATAR_URL_KEY';
const DEVICENAME_KEY = 'DEVICENAME_KEY';
const CUSTOMER_NAME_KEY = 'CUSTOMER_NAME_KEY';
const FIREBASE_TOKEN_KEY = 'FIREBASE_TOKEN_KEY';
const AGREE_TERM_KEY = 'AGREE_TERM_KEY';
const AGREE_UPLOAD_TERM_KEY = 'AGREE_UPLOAD_TERM_KEY';
const SKIP_INTRO_KEY = 'SKIP_INTRO_KEY';
const UNIQUE_DEVICE_ID_KEY = 'UNIQUE_DEVICE_ID_KEY';
const LOCATION_TIME_KEY = 'LOCATION_TIME_KEY';

class LocalStorage {
  final box = GetStorage();

  void saveChatSessionID(String value) {
    box.write(CHAT_SESSIONID_KEY, value);
  }

  String? getChatSessionID() {
    return box.read(CHAT_SESSIONID_KEY);
  }

  void saveAccessToken(String value){
    box.write(ACCESSTOKEN_KEY, value);
  }

  String? getAccessToken() {
    return box.read(ACCESSTOKEN_KEY);
  }

  void saveUserID(int value){
    box.write(USERID_KEY, value);
  }

  int? getUserID() {
    return box.read(USERID_KEY);
  }

  void saveDeviceName(String value){
    box.write(DEVICENAME_KEY, value);
  }

  String? getDeviceName() {
    return box.read(DEVICENAME_KEY);
  }

  void saveAvatarUrl(String value){
    box.write(AVATAR_URL_KEY, value);
  }

  String? getAvatarUrl() {
    return box.read(AVATAR_URL_KEY);
  }

  void saveCustomerName(String value){
    box.write(CUSTOMER_NAME_KEY, value);
  }

  String? getCustomerName() {
    return box.read(CUSTOMER_NAME_KEY);
  }

  void saveFirebaseToken(String value){
    box.write(FIREBASE_TOKEN_KEY, value);
  }

  String? getFirebaseToken() {
    return box.read(FIREBASE_TOKEN_KEY);
  }

  void saveAgreeTerm(String value){
    box.write(AGREE_TERM_KEY, value);
  }

  String? getAgreeTerm() {
    return box.read(AGREE_TERM_KEY);
  }

  void saveAgreeUploadTerm(String value){
    box.write(AGREE_UPLOAD_TERM_KEY, value);
  }

  String? getAgreeUploadTerm() {
    return box.read(AGREE_UPLOAD_TERM_KEY);
  }

  void saveSkipIntro(){
    box.write(SKIP_INTRO_KEY, 'haha');
  }

  String? getSkipIntro() {
    return box.read(SKIP_INTRO_KEY);
  }

  void saveUniqueDeviceId(String value){
    box.write(UNIQUE_DEVICE_ID_KEY, value);
  }

  String? getUniqueDeviceId() {
    return box.read(UNIQUE_DEVICE_ID_KEY);
  }

  void saveLocationTime(DateTime value){
    final string = value.toIso8601String();
    box.write(LOCATION_TIME_KEY, string);
  }

  DateTime? getLocationTime() {
    final String? string = box.read(LOCATION_TIME_KEY);
    if(string == null) return null;
    return DateTime.tryParse(string);
  }

  void removeCredentials(){
    box.remove(USERID_KEY);
    box.remove(ACCESSTOKEN_KEY);
    box.remove(AVATAR_URL_KEY);
    box.remove(CUSTOMER_NAME_KEY);
  }

  void removeAccessToken(){
    box.remove(ACCESSTOKEN_KEY);
  }
}