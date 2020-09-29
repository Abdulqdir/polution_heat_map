import 'package:geolocator/geolocator.dart';

class Location {
  double longitude;
  double latitude;

  double getLat() {
    return this.latitude;
  }

  double getLong() {
    return this.longitude;
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      longitude = position.longitude;
      latitude = position.latitude;
    } catch (e) {
      print(e);
    }
  }

  /*Future<dynamic> getLocation() async {
    double lat;
    double long;
    Location location = Location();
    await location.getCurrentLocation();
    LatLng data = LatLng(location.latitude, location.longitude);
    return data;
  }*/
}
