
import 'package:get_storage/get_storage.dart';

const CHAT_SESSIONID_KEY = 'CHAT_SESSIONID_KEY';
const ACCESSTOKEN_KEY = 'ACCESSTOKEN_KEY';
const USERID_KEY = 'USERID_KEY';
const USERNAME_KEY = 'USERNAME_KEY';
const AVATAR_URL_KEY = 'AVATAR_URL_KEY';
const DEVICENAME_KEY = 'DEVICENAME_KEY';
const PHONE_KEY = 'PHONE_KEY';
const CUSTOMER_NAME_KEY = 'CUSTOMER_NAME_KEY';
const FIREBASE_TOKEN_KEY = 'FIREBASE_TOKEN_KEY';
const AGREE_TERM_KEY = 'AGREE_TERM_KEY';

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

  void saveUsername(String value){
    box.write(USERNAME_KEY, value);
  }

  String? getUsername() {
    return box.read(USERNAME_KEY);
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

  void savePhone(String value){
    box.write(PHONE_KEY, value);
  }

  String? getPhone() {
    return box.read(PHONE_KEY);
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

  void removeCredentials(){
    box.remove(USERNAME_KEY);
    box.remove(USERID_KEY);
    box.remove(ACCESSTOKEN_KEY);
    box.remove(AVATAR_URL_KEY);
    box.remove(PHONE_KEY);
    box.remove(CUSTOMER_NAME_KEY);
  }

  void removeAccessToken(){
    box.remove(ACCESSTOKEN_KEY);
  }
}