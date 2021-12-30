
String resolveUrl(String url, String host){
  return url.contains('http') ? url : '$host$url';
}