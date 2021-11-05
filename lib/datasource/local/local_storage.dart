
import 'package:get_storage/get_storage.dart';

const CHAT_SESSIONID_KEY = 'CHAT_SESSIONID_KEY';
const ACCESSTOKEN_KEY = 'ACCESSTOKEN_KEY';
const USERID_KEY = 'USERID_KEY';
const USERNAME_KEY = 'USERNAME_KEY';
const PWD_KEY = 'PWD_KEY';
const AVATAR_URL_KEY = 'AVATAR_URL_KEY';
const STORE_CODE_KEY = 'STORE_CODE_KEY';
const STORE_WEBSITEID_KEY = 'STORE_WEBSITEID_KEY';
const DEVICENAME_KEY = 'DEVICENAME_KEY';
const PHONE_KEY = 'PHONE_KEY';
const CUSTOMER_NAME_KEY = 'CUSTOMER_NAME_KEY';

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

  void savePwd(String value){
    box.write(PWD_KEY, value);
  }

  String? getPwd() {
    return box.read(PWD_KEY);
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

  void saveStoreCode(String value){
    box.write(STORE_CODE_KEY, value);
  }

  String? getStoreCode() {
    return box.read(STORE_CODE_KEY);
  }

  void saveStoreWebsiteId(int value){
    box.write(STORE_WEBSITEID_KEY, value);
  }

  int? getStoreWebsiteId() {
    return box.read(STORE_WEBSITEID_KEY);
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

  void removeCredentials(){
    box.remove(USERNAME_KEY);
    box.remove(USERID_KEY);
    box.remove(PWD_KEY);
    box.remove(ACCESSTOKEN_KEY);
    box.remove(STORE_CODE_KEY);
    box.remove(STORE_WEBSITEID_KEY);
    box.remove(AVATAR_URL_KEY);
    box.remove(PHONE_KEY);
    box.remove(CUSTOMER_NAME_KEY);
  }

  void removeAccessToken(){
    box.remove(ACCESSTOKEN_KEY);
  }
}