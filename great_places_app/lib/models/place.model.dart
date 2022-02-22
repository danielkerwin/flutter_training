import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String? address;

  const PlaceLocation({
    this.latitude = 0,
    this.longitude = 0,
    this.address,
  });
}

class Place {
  final String id;
  final String title;
  final File image;
  PlaceLocation? location;

  Place({
    required this.id,
    required this.title,
    required this.image,
    this.location,
  });
}
