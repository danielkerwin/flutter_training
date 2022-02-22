import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleUrls {
  static staticApi(double lat, double lng) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C$lat,$lng';
  }

  static geocodeApi(double lat, double lng) {
    return 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng';
  }
}

class LocationService {
  static String generateLocationPreviewImage(double lat, double long) {
    final apiKey = dotenv.get('GOOGLE_API_KEY');
    return '${GoogleUrls.staticApi(lat, long)}&key=$apiKey';
  }

  static Future<String?> getPlaceAddress(double lat, double long) async {
    final apiKey = dotenv.get('GOOGLE_API_KEY');
    final url = Uri.parse('${GoogleUrls.geocodeApi(lat, long)}&key=$apiKey');
    try {
      final response = await http.get(url);
      final body = json.decode(response.body) as Map<String, dynamic>;
      final address = body['results'][0]['formatted_address'];
      return address;
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }
}
