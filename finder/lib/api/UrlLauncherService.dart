import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncherService {
  Future<LatLng> getUserLocation() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      if (result == LocationPermission.denied) {
        return LatLng(37.3608681, 126.9306506);
      }
    }
    if (status == LocationPermission.deniedForever) {
      return LatLng(37.3608681, 126.9306506);
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }
  
  String convertPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll('-', '');
  }

  void launchCaller(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}