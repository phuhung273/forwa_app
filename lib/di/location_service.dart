
import 'package:geolocator/geolocator.dart';

const LOCATION_WARNING_MESSAGE = 'Quyền truy cập vị trí đã bị tắt';
const LOCATION_WARNING_DESCRIPTION = 'Forwa không thể tìm các sản phẩm gần bạn!';

class LocationService {

  Future<Position?> here() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }
}