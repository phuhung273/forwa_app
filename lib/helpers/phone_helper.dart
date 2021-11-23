

String formatPhoneNumber(String phone){
  return phone[0] == '0' ? '+84' + phone.substring(1, phone.length) : phone;
}