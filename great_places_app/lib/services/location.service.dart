import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationApi {
  static staticApi(double lat, double long) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C$lat,$long';
  }
}

class LocationService {
  static String generateLocationPreviewImage(double lat, double long) {
    final apiKey = dotenv.get('GOOGLE_API_KEY');
    return '${LocationApi.staticApi(lat, long)}&key=$apiKey';
  }
}
