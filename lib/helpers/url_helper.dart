
import '../constants.dart';

String resolveUrl(String url){
  return url.replaceAll(r'\', '/').resolveDevelopmentUrl();
}

extension on String {
  String resolveDevelopmentUrl(){
    return replaceAll('http://localhost', HOST_URL);
  }
}