
String resolveUrl(String url, String host){
  return url.contains('http') ? url : '$host$url';
}

/// Get /product from /product?id=1
String getEndPoint(String url){
  return url.split('?').first;
}